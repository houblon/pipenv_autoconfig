# Get Python version and create new virtualenv
echo Which version of Python are you using for your virtualenv?
read py_version
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
pylint_dev_install='[dev-packages]\
pylint = "*"\
\
[scripts]\
install_pylint = "pipenv install pylint"'
sed -i '' "s/\[dev-packages\]/$pylint_dev_install/g" Pipfile


# Install pylint
pipenv install
pipenv run install_pylint
