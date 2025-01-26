import os, inspect, re

# HELPER FUNCTIONS
def get_file_paths(path):
    """
    Given a path, returns a python list of absolute file paths inside target.

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
        # LIST ALL ITEMS IN THE DIRECTORY
        paths = [os.path.join(filename) for filename in os.listdir(path)]
        # KEEPS FULL PATHS FOR ALL ITEMS BEING FILES EXCLUSIVELY
        paths = [path for path in paths if os.path.isfile(path)]

    # FUNCTON OUTPUT
    return paths


def parse_the_docstring():
    """
    Parses a docstring and returns a list of  (no arguments required).

    This function purpose is to be called from/by another function.
    Once called, this function will parse the docstring of the function from
    which it is called and return the url which is inside.
    There is no magic, the url which have to be extracted from the
    docstring must be encapsulated between backticks.
    """

    # BASIC SETTINGS & INITIALIZATION (retrieve the docstring to be parsed)
    regex = r'(?i)(?<=.`).*(?=`)'                # Regex for docstring parsing
    frame = inspect.stack()[1]                   # Get the caller's stack frame
    function = frame[0].f_globals.get(frame[3])  # Get the target function name
    docstring = function.__doc__                 # Gets the dosctring to parse

    # FUNCTION OUTPUT
    return re.findall(regex, docstring)