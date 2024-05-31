#!/usr/bin/env bash

# This script will build Go executables for multiple platforms

# Sourced from https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-20-04

package=$1
if [[ -z "$package" ]]; then
  echo "usage: $0 <package-name>"
  exit 1
fi

package_split=(${package//\// })
package_name=${package_split[-1]}
    
# List of platforms we would like to build for
# Supported values can be obtained by running "go tool dist list"
# Value for current system is shown with "go version" 
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

    echo Building for $platform
    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $package
    if [ $? -ne 0 ]; then
           echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done