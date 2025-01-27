import requests, re
from os import makedirs
from bs4 import BeautifulSoup
from os.path import normpath, abspath, join, dirname
from urllib.parse import urlsplit
from Core.Utils.helpers import parse_the_docstring


# MAIN FUNCTIONS
def download_country_data(country, dest_folder=None, max_file=None):
    """
    Downloads the given country data file(s) to the given destination folder.

    Data files are downloaded from `https://insideairbnb.com/get-the-data/`

    Args:
        country (str): The country for which to download data.
        dest_folder (str, optional): The local folder path to save the file. 
                Defaults to "../../Data/Downloads", which is relative to the
                script's location (e.g., `<script_loc>/../../Data/Downloads`).
        max_file (int): Whether to limit the number of files to download.
                        Defaults to None which means 'no limit' or 'all files'.

    Returns:
        None: Downloads the file and saves it to the specified folder.
    """

    # INITIALIZATION & BASIC SETTINGS
    urlset = parse_the_docstring() # Gets the list of urls (i.e. the main page)

    # DEFINES VALIDATION CRITERIA FOR UNDERLYING URLS
    # >> url prefix, file prefix (clean country name), target file extension
    netloc, country, ext = 'data.insideairbnb.com', country.lower(), '.csv.gz'

    # # CHECK THE EXISTENCE OF THE DESTINATION DIRECTORY AND CREATE IT IF NOT
    folder = set_destination_directory(path=dest_folder)

    # GETS WEB PAGE CONTENT AS A `Beautifulsoup` OBJECT FOR EASIER PARSING
    soup = BeautifulSoup(get_url_content(urlset[0]), 'html.parser')

    # ITERATE OVER EACH HYPERLINK CONTAINED INTO THE RETRIEVED WEB PAGE
    count = 0
    for tag in soup.find_all('a', href=True):
        url = tag['href']                          # Extract sub-url from `tag`
        filename = get_filename(url, country, ext) # Change url into a filename

        if filename and urlsplit(url).netloc == netloc:  # download cond. met ?
            count += 1                                   # Download counter
            download_file(url, folder, filename)         # Write file on disk

        if max_file and count >= max_file:               # Download limit met ?
            break
    
    # FUNCTION FEEDBACK TO LOG
    print("\033[K", end="")                              # Clear the first line
    print(f"\nDownload complete.\n>>> {count} files downloaded in: {folder}")


def download_amazon_products_data(dest_folder=None, max_file=None):
    """
    Downloads Amazon product data file(s) to the specified destination folder.

    The data files are hosted at:
    `https://huggingface.co/datasets/Marqo/amazon-products-eval/tree/main/data`

    Direct interaction with this webpage involves querying an API in background, 
    which can be cumbersome. This function automates the process by querying the
    API directly to the following url:
    `https://huggingface.co/api/datasets/Marqo/amazon-products-eval/tree/main/data`

    Args:
        dest_folder (str, optional): The local folder path where the file(s) will
            be saved. Defaults to "../../Data/Downloads", relative to the script's
            location (e.g., `<script_location>/../../Data/Downloads`).
        max_file (int): Whether to limit the number of files to download.
                        Defaults to None which means 'no limit' or 'all files'.

    Returns:
        None: Downloads the data file(s) and saves them to the specified folder.
    """

    # INITIALIZATION & BASIC SETTINGS
    prefix = 'https://huggingface.co'  # Prefix of urls to the files
    urlset = parse_the_docstring()     # Gets the list of urls (i.e. main page)

    # # CHECK THE EXISTENCE OF THE DESTINATION DIRECTORY AND CREATE IT IF NOT
    folder = set_destination_directory(path=dest_folder)

    # GETS LIST OF FILE PATH SUFFIXES TO DOWNLOAD
    api_response_json = get_url_content(urlset[1], resp_type='json')
    file_name_fragments = [item.get('path') for item in api_response_json]

    # GETS ALL HYPERLINKS ON HOSTING PAGE TO BUILD A FILE DOWNLOAD URL PATTERN
    page = BeautifulSoup(get_url_content(urlset[0]), 'html.parser')
    urls = [tag['href'] for tag in page.find_all('a', href=True)]

    # LOOKING FOR A DIRECT FILE DOWNLOAD URL PATTERN FROM RETRIEVED HYPERLINKS
    model = file_name_fragments[0]
    options = [item for item in urls if 'resolve' in item and model in item]

    # BUILDING A FILE DOWNLOAD URL PATTERN
    pattern = re.sub(re.escape(model), '{}', f'{prefix}{options[0]}').format

    # DOWNLOADS FILES
    count = 0
    for fragment in file_name_fragments:
        # Build full download url
        url = pattern(fragment)
        # Change path `fragment` into a valid file name
        filename = re.sub(r'^\W*|\W*$', '', fragment)  # Remove ugly characters
        filename = re.sub(r'\s*/+\s*', '_', fragment)  # Replaces '/' by "_"
        # Downloads file
        count += 1
        download_file(url, folder, filename)   # Write file on disk

        if max_file and count >= max_file:               # Download limit met ?
            break
    
    # FUNCTION FEEDBACK TO LOG
    print("\033[K", end="")                              # Clear the first line
    print(f"\nDownload complete.\n>>> {count} files downloaded in: {folder}")


def download_file(url, folder, filename):
    """
    Downloads a file from the given URL and saves it to the destination folder.

    Args:
        url (str): The URL of the file to download. Should point directly to a
                   downloadable file, with no intermediate redirects or pages.
        folder (str): Path to the local folder to save the downloaded file.
        filename (str): The desired filename for the downloaded file.

    Returns:
        None
    """

    # INITIALIZATION & BASIC SETTINGS
    buf_size = 8192              # Chunk size for downloading files (i.e. 8 KB)
    
    # DOWNLOADS THE FILE
    resp = get_url_content(url, resp_type='stream')  # Gets the response object
    filepath = join(folder, filename)                # File destination path

    # SAVES THE FILE
    if resp:
        # Computes the download rate with respect to chunk size and file size
        dlrate = buf_size/int(resp.headers.get("Content-Length", float('inf')))

        # Writing file on disk
        with open(filepath, "wb") as file:
            #print(response.headers)
            for i, chunk in enumerate(resp.iter_content(chunk_size=buf_size)):
                # Write the chunk to the file
                file.write(chunk)

                # Computes completion percentage
                completion = round(100*(i+1)*dlrate, 2)

                # Clear the first line then display the updated progress
                print("\033[K", end="")
                print(f"> downloading {filename}... ({completion}%)", end="\r")


# HELPER FUNCTIONS
def get_url_content(url, resp_type='text'):
    """
    Uses the `requests` library to query the given URL and return its response.

    By default, the function returns the content of the URL as text. However,
    you also can get it as a dictionary when the reponse is a json file, and at
    last, for file downloads purpose, you can set the response type to a stream
    (refer to `requests` library for more details).

    A c
    
    By default the returned `response` of the function is core text of the url,
    but for files downloading purpose one can set the function behavior to get
    the `response` as a `stream` (see args below and `requests` library)

    Args:
        url (str): url to request.
        resp_type (str, optional): The type of response to return. Options are:
                  - 'stream': For file downloads (returns a streamed response).
                  - 'json': For JSON response data (returns parsed JSON).
                  - 'text': For plain text response (default).

    Returns:
        requests.models.Response: The HTTP response object from `requests`,
                                  or `None` if an exception occurs.
    """

    # INITIALIZATION & BASIC SETTINGS
    stream = True if resp_type == 'stream' else False # `requests.get` argument
    response = None                                   # Default function output

    # GETS CONTENT FROM THE GIVEN URL
    try:
        resp = requests.get(url, stream=stream)    # Gets url content object
        resp.raise_for_status()                    # Get & Push html exceptions

        # ADJUST FUNCTION OUTPUT ACCORDING TO THE REQUESTED BEHAVIOR
        if resp_type == 'text':
            resp.encoding = resp.apparent_encoding   # Replaces ugly characters
            response = resp.text                     # Gets required output
        else:
            response = resp if stream else resp.json()   # Gets required output

    except requests.exceptions.RequestException as e:
        print(f"Error during download: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

    # FUNCTION OUTPUT
    return response


def get_filename(url, prefix, suffix):
    """
    Converts a URL to a valid filename and validates it against given rules.

    This function processes the input URL to generate a filesystem-safe filename. 
    It then checks whether the resulting filename meets the specified criteria, 
    ensuring compatibility and adherence to the requirements.

    The filename is constructed from the URL's `path` component. For details 
    on how the `path` is extracted, refer to the `urlsplit` function in the 
    `urllib` library.

    The validation rules ensure that the generated filename starts with the 
    specified prefix and ends with the specified suffix, as required. 

    Args:
        url (str): The URL pointing directly to the file to be downloaded.
        prefix (str): Any string the file name must starts with.
        sufix (str): any string the file name must ands with.
    
    Returns:
        A filename (i.e. a string) if the validation passes and otherwise None.
    """

    # REMOVES NON-WORD CHARACTERS FROM THE START AND END OF THE URL'S PATH
    filename = re.sub(r'^\W*|\W*$', '', urlsplit(url).path)

    # REPLACES ANY '/' BY A SINGLE '_'
    filename = re.sub(r'\s*/+\s*', '_', filename).lower()

    # CHECKING VALIDATION REQUIREMENTS
    if (not filename.startswith(prefix)) or (not filename.endswith(suffix)):
        filename = None

    # FUNCTION OUTPUT
    return filename


def set_destination_directory(path=None):
    """
    Creates a folder to the given path or on project root otherwise.

    Args:
        path (str, optional): The local folder path to check for existence. 
            Defaults to "../../Data/Downloads", which is relative to the
            script's location (e.g., `<script_loc>/../../Data/Downloads`).

    Returns:
        str: The absolute path to the destination folder.
    """
    # DESTINATION DIRECTORY CONFIGURATION (i.e. full absolute path)
    defdir = abspath(join(dirname(__file__), "../../Data/Downloads"))
    folder = normpath(path) if path else defdir

    # CHECK THE EXISTENCE OF THE DESTINATION DIRECTORY AND CREATE IT IF NOT
    makedirs(folder, exist_ok=True)

    # FUNCTION OUTPUT (i.e. absolute path to the destination folder)
    return folder


#download_country_data('spain', max_file=3)
#download_amazon_products_data(dest_folder=None)