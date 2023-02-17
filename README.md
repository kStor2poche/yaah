# Yet another AUR helper  
  
A temporary side project of mine made to offer a simple command-line helper for the Arch user repository, in bash.  
  
## Usage  
  
General usage is `yaah [switch] [packages]`, where `[switch]` can be one of the following options :
- `-s` for installing packages  
- `-r` for removing packages (currently not implemented)  
- `-u` for updating the packages found in `$GITPATH`  
- `-g` for modifying the `GITPATH` variable, i.e. the path where the aur package folders are stored  
- `-ge` for printing `$GITPATH`  
- `-h` for printing a similar help prompt  
  
## To do
  
Some options are planned to be implemented before a first proper release can be made, namely package search and package removal with different options depending on how much cleaning the user is willing to have done (i.e. removing packages that are already built or not).  
  
There are also some minor possible improvements listed in each script's first lines.  
