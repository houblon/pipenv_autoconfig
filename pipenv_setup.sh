#!/bin/bash
# Get Python version and create new virtualenv

# "set -e" will cause bash to exit with an error on any simple command.
# Example: exit if user specifies a not-installed python version 
set -e 
py_version="none" # no default for version number
pylint="no"       # This is our flag to install (or not) pylint

# Process the command line arguments
while getopts 'lhv:' OPTION; do
  case "$OPTION" in
    l)
      pylint="yes" 
      ;;

    h) # print help mesage
      echo 'Usage: pipenv_autocoinfig [ -l -h -v number] '
      echo '-l option installs pylint as part of the process'
      echo '-v followed by a number (ex: 3.6) sets your Python version number'
      echo '-h prints this help message'
      exit 1
      ;;

    v) # -v allows use to set python version on command line and not be asked
      py_version="$OPTARG"
      ;;
    ?) # print help message if unknown argument given
      echo 'Usage: pipenv_autocoinfig [ -l -h -v number] '
      echo '-l option installs pylint as part of the process'
      echo '-v followed by a number (ex: 3.6) sets your Python version number'
      echo '-h prints this help message'      
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

# Start the install process by checking py_version, ask if not specified
if [ $py_version == "none" ]
  then
    echo 'Which Python version are you using for your virtualenv? (ex. 3.6):'
    read py_version
  else
    echo "installing pipenv for python $py_version"
fi

pipenv --python $py_version

# Get path to new virtualenv
venv_path="$(pipenv --venv)"

# Create string for VS Code settings.json
json="{
  \"python.venvPath\": \"$venv_path\",
  \"python.linting.pylintPath\": \"$venv_path/bin/pylint\"
}"

# Create and write to settings.json
mkdir -p .vscode
settings_file='.vscode/settings.json'
touch $settings_file

if [ -f "$settings_file" ]
  then 
    echo "$json" > "$settings_file"
fi

# Update Pipfile to include pylint and associated install script


if [ "$pylint" == "no" ]
  then
  echo 'Install pylint? (y/n):'
  read pylint
    if [ "$pylint" == "y" ]
      then
        pylint="yes"
      else
      echo "pylint not installed"
      echo "done"
      exit
    fi
fi

# Install pylint
if [ "$pylint" == "yes" ]
	then
  echo ' Install pyint'
  pylint_dev_install='[dev-packages]\
  pylint = "*"\
  \
  [scripts]\
  install_pylint = "pipenv install pylint"' 
  sed -i '' "s/\[dev-packages\]/$pylint_dev_install/g" Pipfile
  pipenv install
  pipenv run install_pylint
fi

