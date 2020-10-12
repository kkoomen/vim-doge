@echo off
set ROOT_DIR=%~dp0
cd %ROOT_DIR%

set packages=

:gen_package_names
if [%1]==[] goto package_names_ready
  set package_name=tree-sitter-%1
  @echo Preparing to install package: %package_name%
  set packages=%packages% %package_name%
  shift
goto gen_package_names

:package_names_ready
if exist .\node_modules\ goto install_packages
  call npm i --only=production --no-save

:install_packages
if "%packages%"=="" goto run_build
  call npm i --no-save %packages%

:run_build
if exist .\dist\index.js goto done
  call npm run build

:done
