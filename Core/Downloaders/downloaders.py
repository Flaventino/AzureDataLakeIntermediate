import requests, re
from os import makedirs
from bs4 import BeautifulSoup
from os.path import normpath, abspath, join, dirname
from urllib.parse import urlsplit

# MAIN FUNCTIONS
def download_country_data(country, dest_folder=None):
    """
    Downloads give country data file(s) to the given destination folder.

    Data files are downloaded from <https://insideairbnb.com/get-the-data>

    Args:
        country (str): The country for which to download data.
        dest_folder (str, optional): The local folder path where the file will 
            be saved. If not provided, defaults to "<root>/Data/Downloads", 
            where <root> is the root directory of the project.
    
    Returns: None (Simply download file and save it to the destination folder)
    """

    # INITIALIZATION & BASIC SETTINGS
    ext = '.csv.gz'                                # Target file extensions
    url = 'https://insideairbnb.com/get-the-data/' # Url to the data sources
    netloc = 'data.insideairbnb.com'               # Prefix of underlying urls
    country = country.lower()                      # Normalize country name
    default_relative_path = "../../Data/Downloads/" # Default directory path

    # DESTINATION DIRECTORY CONFIGURATION (i.e. full absolute path)
    defdir = abspath(join(dirname(__file__), default_relative_path))
    folder = normpath(dest_folder) if dest_folder else defdir

    # CHECK THE EXISTENCE OF THE DESTINATION DIRECTORY AND CREATE IT IF NOT
    makedirs(folder, exist_ok=True)

    # GETS WEB PAGE CONTENT AS A `Beautifulsoup` OBJECT FOR EASIER PARSING
    soup = BeautifulSoup(get_url_content(url), 'html.parser')

    # ITERATE OVER EACH HYPERLINK CONTAINED INTO THE RETRIEVED WEB PAGE
    count = 0
    for tag in soup.find_all('a', href=True):
        url = tag['href']                          # Extract sub-url from `tag`
        filename = get_filename(url, country, ext) # Change url into a filename

        if filename and urlsplit(url).netloc == netloc:
            count += 1
            download_file(url, folder, filename)
    
    # FUNCTION FEEDBACK TO LOG
    print("Download process complete.")
    print(f">>> {count} files downloaded in: {folder}")


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

    # DOWNLOADS THE FILE
    response = get_url_content(url, stream=True)
    filename = join(folder, filename)

    # SAVES THE FILE
    if response:
        with open(filename, "wb") as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)


# HELPER FUNCTIONS
def get_url_content(url, stream=False):
    """
    Uses `requests` library to querry the given url and get back its response.

    By default the returned `response` of the function is core text of the url,
    but for files downloading purpose one can set the function behavior to get
    the `response` as a `stream` (see args below and `requests` library)

    Args:
        url (str): url to request.
        stream (bool, optional): Whether to get a stream or text response.
                                 Defaults to False (i.e. default to text resp.)

    Returns:
        a `requests.models.Response` object or None in case of any exceptions.
    """

    # INITIALIZATION & BASIC SETTINGS
    response = None        # Function default output (in case of any exception) 

    # GETS CONTENT FROM THE GIVEN URL
    try:
        resp = requests.get(url, stream=stream)   # Gets url content object
        resp.raise_for_status()                   # Get & Push html exceptions 
        resp.encoding = resp.apparent_encoding    # Replaces special characters

        # ADJUST FUNCTION OUTPUT ACCORDING TO THE REQUESTED BEHAVIOR
        response = resp.text if not stream else resp

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





    #         # print(parts.path)
    #         #print(f'{parts.netloc = } | {parts.path = }')
    #         name = re.sub(r'^\W*|\W*$', '', parts.path) 
    #         name = re.sub(r'\s*/+\s*', '_', name)


#download_country_data('spain')