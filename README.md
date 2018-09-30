# pipenv autoconfig: automated pipenv config, with pylint, for VS Code

This shell script automates setting the path to both the pipenv virtualenv and pylint within the virtualenv, in VS Code, for a new created virtualenv.

It currently does the following:
* Creates a new virtualenv, including asking for a Python version
* Creates a settings.json file in a .vscode directory, with paths for the virtualenv and pylint
* Updates the auto-generated Pipfile to include pylint as a dev dependency
* Adds a script to the auto-generated Pipfile to allow for installation of pylint within the virtualenv

This was born from manually configuring pipenv and pylint in VS Code one too many times, and wanting an easier way. It is by no means robust, and there are undoubtedly ways to improve it, such as adding error handling and validation, as well as making it editor agnostic. Use at your own risk, YMMV, and all that. Please fork and/or issue pull requests, if you’re so inclined. Cheers.