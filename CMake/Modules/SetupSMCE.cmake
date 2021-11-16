#
#  UserConfigVars.cmake
#  Copyright 2021 ItJustWorksTM
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

include_guard ()

find_package (SMCE 1.4 REQUIRED)
# for testing, can change it to SMCE_FOUND, then even it found the smce 1.4
# still will install the library
if(SMCE_FOUND)
    message("libsmce are not int your computer, autoinstalling")

    # set the libSMCE version and the target file basename
    set (SMCE_EXPECTED_TAG 1.4.0)
    set (SMCE_EXPECTED_VERSION 1.4)
    if(UNIX)
        set (SMCE_EXPECTED_ARCH x86_64)
    # for windows
    else()
        set (SMCE_EXPECTED_ARCH AMD64)
    endif()

    set (SMCE_BASENAME "libSMCE-${SMCE_EXPECTED_VERSION}-${CMAKE_SYSTEM_NAME}-${SMCE_EXPECTED_ARCH}-${CMAKE_CXX_COMPILER_ID}")
    if (MSVC)
        string (APPEND SMCE_BASENAME "-Release")
    endif ()

    # target filename and decide where to put it
    if(UNIX)
        set (SMCE_ARK_FILENAME "${SMCE_BASENAME}.tar.gz")
    else()
        set (SMCE_ARK_FILENAME "${SMCE_BASENAME}.zip")
    endif()

    set (SMCE_ROOT "${CMAKE_CURRENT_BINARY_DIR}/smce-autodl")
    file (MAKE_DIRECTORY "${SMCE_ROOT}")
#DEBUG    message("libSMCE-${SMCE_EXPECTED_VERSION}-${CMAKE_SYSTEM_NAME}-${SMCE_EXPECTED_ARCH}-${CMAKE_CXX_COMPILER_ID}")

    # download sha512.txt from github
    file (DOWNLOAD "https://github.com/ItJustWorksTM/libSMCE/releases/download/v${SMCE_EXPECTED_TAG}/sha512.txt"
                "${SMCE_ROOT}/sha512.txt"
                TLS_VERIFY ON)
    file (STRINGS "${SMCE_ROOT}/sha512.txt" SMCE_${SMCE_EXPECTED_VERSION}_SHA512s
                LENGTH_MINIMUM 130) # 128 xnums + 2 padding spaces
    foreach (SMCE_SHA512_LINE ${SMCE_${SMCE_EXPECTED_VERSION}_SHA512s})
        string (SUBSTRING "${SMCE_SHA512_LINE}" 130 -1 SMCE_SHA512_FNAME)
        if (SMCE_SHA512_FNAME STREQUAL SMCE_ARK_FILENAME)
            string (SUBSTRING "${SMCE_SHA512_LINE}" 0 128 SMCE_ARK_HASH)
            message(${SMCE_SHA512_LINE})
                break ()
        endif ()
    endforeach ()

    # downlaod the zip file from github and make it in the corresponding dir
   file (DOWNLOAD "https://github.com/ItJustWorksTM/libSMCE/releases/download/v${SMCE_EXPECTED_TAG}/${SMCE_ARK_FILENAME}"
            "${SMCE_ROOT}/${SMCE_ARK_FILENAME}"
            SHOW_PROGRESS
            TLS_VERIFY ON
            EXPECTED_HASH SHA512=${SMCE_ARK_HASH})
    execute_process (COMMAND "${CMAKE_COMMAND}" -E tar xf "${SMCE_ROOT}/${SMCE_ARK_FILENAME}"
            WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    file (REMOVE_RECURSE "${SMCE_ROOT}")


    add_library (SMCE IMPORTED STATIC)
    target_include_directories (SMCE INTERFACE "${SMCE_ROOT}/include")
    message(${CMAKE_STATIC_LIBRARY_SUFFIX})

    # make the target to the libSMCE_static.a
    set_property (TARGET SMCE PROPERTY IMPORTED_LOCATION "${SMCE_ROOT}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}SMCE_static${CMAKE_STATIC_LIBRARY_SUFFIX}")
    set(SMCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/${SMCE_BASENAME}/lib/cmake/SMCE")
endif()

# refind the package and output the dir to make sure it used the download one
find_package (SMCE 1.4 REQUIRED)
#message("${SMCE_DIR}")
#message ("libSMCE found")
set (SMCE_TARGET SMCE::SMCE)
option (SMCE_LINK_STATIC "Link to libSMCE statically" Off)

if (SMCEGD_SMCE_LINKING STREQUAL "STATIC")
    if (NOT TARGET SMCE::SMCE_static)
        message ("--- libSMCE static library not installed")
    endif ()
    set (SMCE_TARGET SMCE::SMCE_static)
    message (STATUS "libSMCE statically linked")
endif ()

if (APPLE)
    set (CMAKE_BUILD_RPATH "@loader_path/../Frameworks;${CMAKE_BUILD_RPATH}")
    set (CMAKE_INSTALL_RPATH "@loader_path/../Frameworks;${CMAKE_INSTALL_RPATH}")
endif ()
