# cs3b-shared-lib
My own shared library for CS 3B with actual working functions

# IMPORTANT
The functions in this library do not have the same signature as those provided for class because I wanted them to have additional utility. You cannot drop these in as replacements.

# How to use
The makefile in ths repository produces a single statically linked library file `shared.a` containing all of the functions in this repository. You can link this with your program the same way you link individual object files.

This repository also provides an `include` directory with files that provide useful macros. To use this, use the `.include` directive in your file and assemble with `-I path/to/include/dir`.
