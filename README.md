# Go build tools
A collection of scripts and resources for easier Go builds

## Manual operations
The following operations are for running and building an app without using the scripts in this repo. Note the use of `-ldflags` here to allow us to set version information to whatever we want. 

### Running
```shell
go run .
go run -ldflags "-X main.version=1.0.0.0" .
```

### Building
```shell
go build .
go build go run -ldflags "-X main.version=1.0.0.0" .
```

## Scripts
### go-build.sh and go-build.cmd
Pass a module name on the command line and the script will build:
* for each platform/architecture specified
* with a git tag version number burned in
* _[TODO]_ with an icon where possible

```bash
./go-build.sh motivesoft/hype
```
```shell
./go-build.cmd motivesoft/hype
```

#### Usage notes
Requires the following in the `main` package Go code
```go
var version string
```
The git tag (and abbreviated commit checksum) is obtained with this command:
```shell
git describe --tags --long --abbrev=8
```
This specific set of options is used as it seems to create identical results on Windows and Linux 

## Overall set of planned scripts:
* build for current platform only
* build for multiple platforms
* build with git tag version
* build with Windows resources
* combinations of the above

## Resources
The package [go-winres](https://github.com/tc-hib/go-winres) is a (slightly restricted) kind of resource compiler for Go applications on Windows.

Install the package:
```shell
go install github.com/tc-hib/go-winres@latest
```

To simply inject an application icon into a build, a `.syso` file is built by `go-winres` with that icon and that is picked up by the standard build:
```shell
go-winres simply --icon icon.ico
``` 

For a more detailed set of resources, `go-winres` can generate a `json` file that can be edited to provie a larger set of resources. `go-winres` can then 'make' this into a `.syso` file as part of the build process.

Do this once to create a placeholder set of resources:
```shell
go-winres init
```
Edit the resultant `winres/winres.json` file to add references to any icon files and other details.

Build the application with an extra step to create the `.syso` file from the `json` file:
```shell
go-winres make
go build
```
# Installing
## Windows
