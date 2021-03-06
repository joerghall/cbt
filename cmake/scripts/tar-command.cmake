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

get_filename_component(SOURCE_PATH "${SOURCE}" DIRECTORY)
file(RELATIVE_PATH SOURCE_NAME "${SOURCE_PATH}" "${SOURCE}")

#message(FATAL_ERROR "${CMAKE_COMMAND} ${SOURCE_PATH} ARGS -E tar czf ${TARGET} ${SOURCE_NAME}")
exec_program(${CMAKE_COMMAND} ${SOURCE_PATH} ARGS -E tar czf ${TARGET} ${SOURCE_NAME} OUTPUT_VARIABLE output RETURN_VALUE result)

if(NOT result EQUAL 0)
    message(FATAL_ERROR "Failed to pack ${SOURCE} to ${TARGET} with exitcode=${result} output:\n${output}")
else()
    message(STATUS "Packed ${SOURCE} to ${TARGET}")
endif()
