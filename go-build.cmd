@echo off

rem Allow some script magic
setlocal enabledelayedexpansion

rem This script will build Go executables for multiple platforms

rem Converted from https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-20-04

rem Check the input parameter - needs to be the package name
set package=%1
if _%package%_ == __ (
  echo Usage: %~nx0 [package-name]
  goto :EOF
)

rem Split the package name from the input - e.g. "motivesoft/hype" to "hype"
set package_split=%1
set "package_split=%package_split:/= %"
for %%x in (%package_split%) do set package_name=%%x

rem echo PACKAGE_NAME=%package_name%    

rem Now work out the most recent tag which we will parse into a variable and use later.
rem We will use this in the executable name, and also to get the more detailed build version number
for /F "tokens=*" %%g in ('git tag "--sort=taggerdate"') do (
  set tag_string=%%g
)

if "%tag_string%"=="" (
    echo No tag available.
    set tag_string=unknown
    set version_string=unknown
    goto :notag
)

echo Building for tag %tag_string%

rem Now work out some version information which we will parse into a variable and use later.
rem Wrap the arguments to git describe in quotes as the --abbrev clause seems to require it
rem Requires the following in the 'main' package:
rem var version string
rem ** could also consider:
rem    git for-each-ref refs/tags --sort=-taggerdate --format='%(refname:lstrip=2)' --count=1
rem    git for-each-ref refs/tags --sort=-taggerdate --format='%(refname:short)' --count=1
for /F "tokens=*" %%g in ('git describe --all --long "--abbrev=7" %tag_string%') do (
  set version_string=%%g
)

rem Safely rip the "tags/" from the git describe value we just obtained
set "version_string=%version_string:tags/=%"

if "%version_string%"=="" (
    echo No version tag available.
    set version_string=unknown
)

:notag
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
    set output_name=%package_name%-%tag_string%-!GOOS!-!GOARCH!
    if "!GOOS!"=="windows" set output_name=!output_name!.exe

    rem Invoke the build command and check the outcome
    echo Building version %version_string% for %%y
    go build -ldflags "-X main.version=%version_string%" -o !output_name! %package%
    if !ERRORLEVEL! NEQ 0 (
        echo 'An error has occurred! Aborting the script execution...'
        goto :EOF
    ) 
)
