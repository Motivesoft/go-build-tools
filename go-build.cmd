@echo off
setlocal enabledelayedexpansion

rem This script will build Go executables for multiple platforms

rem Converted from https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-20-04

set package=%1
if _%package%_ == __ (
  echo usage: %~nx0 [package-name]
  rem exit 1
)

setlocal enabledelayedexpansion

rem Split the package name from the input - e.g. "motivesoft/hype" to "hype"
set package_split=%1
set "package_split=%package_split:/= %"
for %%x in (%package_split%) do set package_name=%%x

echo PACKAGE_NAME=%package_name%    
rem List of platforms we would like to build for
rem Supported values can be obtained by running "go tool dist list"
rem Value for current system is shown with "go version" 

set platforms=windows/amd64 linux/amd64
echo PLATFORMS=%platforms%    

for %%y in (%platforms%) do ( 
    set platform_split=%%y
    set platform_split=!platform_split:/= !

    set GOOS=
    set GOARCH=
    for %%x in (!platform_split!) do (
        if _!GOOS!_==__ (
            set GOOS=%%x
        ) else (
            set GOARCH=%%x
        )
    )

    echo GOOS=!GOOS!
    echo GOARCH=!GOARCH!
    set output_name=%package_name%-!GOOS!-!GOARCH!
    if "!GOOS!"=="windows" set output_name=!output_name!.exe

    echo !output_name!

)

goto :EOF
platforms=("windows/amd64" "linux/amd64")
for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=$package_name'-'$GOOS'-'$GOARCH
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi    

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $package
    if [ $? -ne 0 ]; then
           echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done