# MIT License
#
# Copyright (c) 2017 Joerg Hallmann
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

# Primitive to download a artifact via http
#
function (artifact_download_http RESULT SOURCE TARGET)

    # Check if the target file exists and remove if found
    if (EXISTS ${TARGET})
        file(REMOVE ${TARGET})
        if (EXISTS ${TARGET})
            message(FATAL_ERROR "artifact_download_http: Failed to remove ${TARGET}")
        endif ()
    endif ()
    file(DOWNLOAD ${SOURCE} ${TARGET} SHOW_PROGRESS TLS_VERIFY off STATUS return_status)
    list(GET return_status 0 status_code)
    if(${status_code} EQUAL 0)
        message(STATUS "artifact_download_http: ${return_status} for URL ${SOURCE}")
    else()
        message(WARNING "artifact_download_http: ${return_status} for URL ${SOURCE}")
    endif()
    set(${RESULT} ${status_code} PARENT_SCOPE)

endfunction (artifact_download_http)

# Primitive to copy a artifact from a local folder
#
function (artifact_download_file RESULT SOURCE TARGET)

    # Check if the target file exists and remove if found
    if (EXISTS ${TARGET})
        file(REMOVE ${TARGET})
        if (EXISTS ${TARGET})
            message(FATAL_ERROR "artifact_download_file: Failed to remove ${TARGET}")
        endif ()
    endif ()

    get_filename_component(TARGET_PATH ${TARGET} DIRECTORY)
    file(COPY ${SOURCE} DESTINATION ${TARGET_PATH})
    set(${RESULT} 0 PARENT_SCOPE)

endfunction ()

# Download an artifact, supports tries over mutiple hosts
#
function (artifact_download SOURCE TARGET)

    if (${SOURCE} MATCHES "^http://.*" OR ${SOURCE} MATCHES "^https://.*")
        if ("${SOURCE}" MATCHES "{ARTIFACTORY}")
            # Try the various locations
            foreach (ARTIFACTORY ${ARTIFACTORIES})
                string(REPLACE "{ARTIFACTORY}" ${ARTIFACTORY} FINAL_SOURCE ${SOURCE})
                message("artifact_download - SOURCE: ${FINAL_SOURCE} TARGET: ${TARGET}")
                artifact_download_http(RESULT ${FINAL_SOURCE} ${TARGET})
                if (${RESULT} EQUAL 0)
                    return()
                endif ()
            endforeach ()
        else ()
            message("artifact_download - SOURCE: ${SOURCE} TARGET: ${TARGET}")
            artifact_download_http(RESULT ${SOURCE} ${TARGET})
            if(${RESULT} EQUAL 0)
                return()
            endif()
        endif ()
    elseif(EXISTS ${SOURCE})
        message(FATAL_ERROR "artifact_download_file not implemented")
    endif()

    message(FATAL_ERROR "Unable to download ${SOURCE} to ${TARGET}")

endfunction ()

function(replace_parameter input_param output_param)

    string(REPLACE "{PACKAGE}" "${PACKAGE}" input_param ${input_param})
    string(REPLACE "{PLATFORM}" "${PLATFORM}" input_param ${input_param})
    string(REPLACE "{VERSION}" "${VERSION}" input_param ${input_param})
    string(REPLACE "{BRANCH}" "${BRANCH}" input_param ${input_param})
    string(REPLACE "{BITNESS}" "${BITNESS}" input_param ${input_param})
    string(REPLACE "{OPTIMIZATION}" "${OPTIMIZATION}" input_param ${input_param})
    string(REPLACE "{EXTENSION}" "${EXTENSION}" input_param ${input_param})

    set(${output_param} ${input_param} PARENT_SCOPE)
endfunction()

function(add_toolset PACKAGE VERSION)

    set(EXTENSION tgz)
    set(LOCATION_NAME ${PACKAGE})
    if (BUILD_LINUX)
        set(PLATFORM linux)
    else()
        set(PLATFORM ${BUILD_OS})
    endif()
    set(FILENAME "{PACKAGE}-{VERSION}-{PLATFORM}.{EXTENSION}")
    set(RELATIVE_PATH "{PACKAGE}/{VERSION}/{PLATFORM}")

    set(artifactory_configuration default)
    set(artifactory ${${artifactory_configuration}_ARTIFACTORY})
    set(artifactory_url https://h1grid.com/artifactory/cbt/devtools/${PACKAGE}/${VERSION}/${PACKAGE}-${VERSION}-${PLATFORM}.{EXTENSION})
    set(artifactory_version 1)
    set(artifactory_cache ${ARTIFACT_TOOLSETS_CACHE})

    # Find all optional parameters name=value and update variables
    foreach (arg ${ARGN})
        string(REGEX MATCHALL "^([a-zA-Z_]+)=(.*)$" matched ${arg})
        set(key ${CMAKE_MATCH_1})
        set(value ${CMAKE_MATCH_2})

        if (matched)
            set(valid_names "|PLATFORM|BRANCH|BITNESS|OPTIMIZATION||CONFIG|EXTENSION|FILENAME|RELATIVE_PATH")
            # Validate the name
            if (key MATCHES "^(|${valid_names})$|")
                set(${key} ${value})
            else ()
                message(FATAL_ERROR "Invalid key name ${key} allowed ${valid_names}")
            endif()
        else ()
            message(FATAL_ERROR "Unprocessed argument ${arg} - '${key}'='${value}'")
        endif ()
    endforeach ()

    # Build final parameter list
    replace_parameter("${artifactory_url}" artifactory_url)
    replace_parameter("${FILENAME}" file_name)
    replace_parameter("${RELATIVE_PATH}" file_path)

    #
    add_artifact("${LOCATION_NAME}" "${artifactory_url}" "${ARTIFACT_TOOLSETS_CACHE}" "${file_path}" "${file_name}")

endfunction()
