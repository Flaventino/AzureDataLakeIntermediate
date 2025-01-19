import os

# HELPER FUNCTIONS
def get_file_paths(path):
    """
    Given a path, returns a python list of file paths.

    When the path is a single file path, output is just a one element list with
    that path. When the path is a directory path, then the output is a list of
    paths to all the files in the directory and only the files.

    Args:
        path (str): Path to a file or directory.
    """

    # INITIALIZATION & BASIC SETTINGS
    paths, path = list(), os.path.normpath(path)

    # CHECKS IF THE PATH IS A FILE OR A DIRECTORY
    if os.path.isfile(path):
        paths.append(path)
    elif os.path.isdir(path):
        paths = [os.path.join(filename) for filename in os.listdir(path)]
        paths = [path for path in paths if os.path.isfile(path)]

    # FUNCTON OUTPUT
    return paths