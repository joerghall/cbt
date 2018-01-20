# C/C++ build support tools - cbt 

Because cbt is utilizing submodules we recommend to use git aliases
 
## Goal

Cbt is a extension for cmake to allow build c/c++ standalone applications 
without having to deal with compiler and 3rd party components.

- Adopting best practise for cmake
- Provide common 3rd parties
- Minimal build machine setup with jenkins\teamcity
- Integration git travis, appveyor and similar systems

Supported platforms

- Linux
- OSX
- Windows

Compiler
- gcc
- clang
- msvc

 
```bash
# Aliases to better interact with submodules
#
git config --global alias.ll "log --pretty='format:%h %<(12,trunc)%ce %cd %s' --date=short"
git config --global alias.wd "diff --color-words='[A-z_][A-z0-9_]*'"
git config --global alias.scheckout '!sh -c "git checkout $1 $2 $3 $4 $5 $6 && git submodule sync --recursive && git submodule update --init"' -
git config --global alias.spull '!git pull --rebase && git submodule sync --recursive && git submodule update --init --rebase --recursive'
git config --global alias.spush 'push --recurse-submodules=on-demand'

# Useful settings
#
git config --global push.default simple
git config --global pull.rebase true
```

## Setup a new git repository with cbt

```bash
git submodule add ../../joerghall/cbt.git _submodules/cbt
git submodule init --update
```


## Clone and build repositories with cbt

## Naming schemas

tool - not used for linking or compiling, just do a specific task
devtool - needed to compile and link the project
component - thirdparty library 

o0 - optimization level
x86 - 32 bit x86
x64 - 64 bit x86 architecture
arm32 - ...
arm64 - ...

For Windows default is mt even for debug builds with iterator setting 0

linux - gcc, std lib?
windows - vc120,vc140,vc150 ... 
osx - 10.10

### General package layout

package - version - <>

### Versions 
