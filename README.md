# Go build tools
A collection of scripts and resources for easier Go builds

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

# Building
## Other platforms
## Multiple platforms
## Versioning
### Manual
### Git tags
## Resources
### Icons
### Other

# Installing
## Windows

# Resources
