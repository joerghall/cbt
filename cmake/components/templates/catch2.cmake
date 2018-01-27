# MIT License
#
# Copyright (c) 2018 Joerg Hallmann
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# https://github.com/joerghall/cbt
#
cmake_minimum_required(VERSION 3.0)

add_library(catch2 INTERFACE IMPORTED

)

#target_include_directories(catch2 [SYSTEM] [BEFORE]
#    <INTERFACE|PUBLIC|PRIVATE> [items1...]
#    [<INTERFACE|PUBLIC|PRIVATE> [items2...] ...]
#)
#
#set_property(<GLOBAL                            |
#    DIRECTORY [dir]                   |
#    TARGET    [target1 [target2 ...]] |
#    SOURCE    [src1 [src2 ...]]       |
#    INSTALL   [file1 [file2 ...]]     |
#    TEST      [test1 [test2 ...]]     |
#    CACHE     [entry1 [entry2 ...]]>
#    [APPEND] [APPEND_STRING]
#    PROPERTY <name> [value1 [value2 ...]])
#INTERFACE_INCLUDE_DIRECTORIES
#INTERFACE_COMPILE_DEFINITIONS
