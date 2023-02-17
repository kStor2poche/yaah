## Yet another AUR helper  
  
A temporary side project of mine made to offer a simple command-line helper for the Arch user repository, in bash.  
  
# Usage  
`yaah [switch] [packages]`  
where `[switch]` can be one of  
- `s` for installing packages  
- `r` for removing packages (currently not implemented)  
- `u` for updating the packages found in `$GITPATH`  
- `g` for modifying the `GITPATH` variable, i.e. the path where the aur package folders are stored  
- `ge` for printing `$GITPATH`  
- `h` for printing a similar help prompt  
