@echo off

rem Allow some script magic
setlocal enabledelayedexpansion

rem This script will build Go executables for multiple platforms

rem Converted from https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-20-04

rem Check the input parameter - needs to be the package name
set package=%1
if _%package%_ == __ (
  echo usage: %~nx0 [package-name]
  goto :EOF
)

rem Split the package name from the input - e.g. "motivesoft/hype" to "hype"
set package_split=%1
set "package_split=%package_split:/= %"
for %%x in (%package_split%) do set package_name=%%x

rem echo PACKAGE_NAME=%package_name%    

rem List of platforms we would like to build for
rem Supported values can be obtained by running "go tool dist list"
rem Value for current system is shown with "go version" 
set platforms=windows/amd64 linux/amd64
rem echo PLATFORMS=%platforms%    

rem For each platform, set the relevant environment variables and invoke the build
for %%y in (%platforms%) do ( 
    set platform_split=%%y
    set platform_split=!platform_split:/= !

    rem Extract the two components of the platform into environment variables
    set GOOS=
    set GOARCH=
    for %%x in (!platform_split!) do (
        if _!GOOS!_==__ (
            set GOOS=%%x
        ) else (
            set GOARCH=%%x
        )
    )

    rem echo GOOS=!GOOS!
    rem echo GOARCH=!GOARCH!

    rem Name the built application using platform details, and add .exe for Windows 
    set output_name=%package_name%-!GOOS!-!GOARCH!
    if "!GOOS!"=="windows" set output_name=!output_name!.exe

    rem Invoke the build command and check the outcome
    echo Building for %%y
    go build -o !output_name! %package%
    if !ERRORLEVEL! NEQ 0 (
        echo 'An error has occurred! Aborting the script execution...'
        goto :EOF
    ) 
)