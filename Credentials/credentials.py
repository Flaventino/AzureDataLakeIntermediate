from dotenv import dotenv_values

def getenv(passname):
    """
    Returns the secret corresponding to the given password name.

    Parses environment variables, i.e the '.env' file, in search of the name
    that has been passed in argument. If one is find then the related secret
    is returned.

    Args:
        passname (str): Name of the secret to retrieve.
    """
    return {**dotenv_values()}[passname]