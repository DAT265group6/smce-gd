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
if(NOT SMCE_FOUND)
    message("libsmce are not int your computer, autoinstalling")

    # set the libSMCE version and the target file basename
    set (SMCE_EXPECTED_TAG 1.4.0)
    set (SMCE_EXPECTED_VERSION 1.4)
    set (SMCE_EXPECTED_ARCH x86_64)
    set (SMCE_BASENAME "libSMCE-${SMCE_EXPECTED_VERSION}-${CMAKE_SYSTEM_NAME}-${SMCE_EXPECTED_ARCH}-${CMAKE_CXX_COMPILER_ID}")
    if (MSVC)
        string (APPEND SMCE_BASENAME "-Release")
    endif ()

    # target filename and decide where to put it
    set (SMCE_ARK_FILENAME "${SMCE_BASENAME}.tar.gz")
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
message("${SMCE_DIR}")
message ("libSMCE found")
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

#    file (GLOB WA_BOOST_LIBS LIST_DIRECTORIES false "${SMCE_ROOT}/lib64/boost/*")
#    message ("Found the following Boost workaround libs: ${WA_BOOST_LIBS}")
#    if (WA_BOOST_LIBS)
#        add_library (WA_Boost INTERFACE)
#        foreach (WA_BLIB ${WA_BOOST_LIBS})
#            if (IS_SYMLINK "${WA_BOOST_LIBS}")
#                message (FATAL_ERROR "Workaround Boost lib \"${WA_BLIB}\" is a symlink")
#            elseif (IS_DIRECTORY "${WA_BOOST_LIBS}")
#                message (FATAL_ERROR "Workaround Boost lib \"${WA_BLIB}\" is a directory")
#            endif ()
#            target_link_libraries (WA_Boost INTERFACE "${WA_BLIB}")
#        endforeach ()
#        target_link_libraries (SMCE INTERFACE WA_Boost)
#    endif ()
#endif()

#include (FetchContent)
#message ("--- Downloading libsmce")
#FetchContent_Declare (libsmce
#        GIT_REPOSITORY "https://github.com/ItJustWorksTM/libSMCE"
#        GIT_TAG v1.4.0
#        GIT_SHALLOW On)
#FetchContent_GetProperties (libsmce)
#if (NOT libsmce_POPULATED)
#    FetchContent_Populate (libsmce)
#    message ("--- populated libsmce")
#    file (READ "${libsmce_SOURCE_DIR}/CMakeLists.txt" libsmce_cmakelists)
#    string (REPLACE "add_dependencies (SMCE ArdRtRes)" "add_dependencies (SMCE_static ArdRtRes)" libsmce_cmakelists "${libsmce_cmakelists}")
#    file (WRITE "${libsmce_SOURCE_DIR}/CMakeLists.txt" "${libsmce_cmakelists}")
#
#    set (SMCE_BUILD_SHARED Off CACHE INTERNAL "")
#    set (SMCE_BUILD_STATIC On CACHE INTERNAL "")
#    set (SMCE_CXXRT_LINKING "STATIC" CACHE INTERNAL "")
#    set (SMCE_BOOST_LINKING "${PYSMCE_BOOST_LINKING}" CACHE INTERNAL "")
#    add_subdirectory ("${libsmce_SOURCE_DIR}" "${libsmce_BINARY_DIR}" EXCLUDE_FROM_ALL)
#endif ()


#find_package (SMCE 1.4 REQUIRED)
#add_library(SMCE 1.4 INTERFACE)
#add_library (SMCE_Boost INTERFACE)
#if ("${SMCE_BOOST_LINKING}" STREQUAL "STATIC")
#    set (Boost_USE_STATIC_LIBS True)
#else ()
#    set (Boost_USE_STATIC_LIBS False)
#endif ()

#if (MSVC)
#    find_package (Boost 1.74 COMPONENTS atomic filesystem date_time)
#else ()
#    find_package (Boost 1.74 COMPONENTS atomic filesystem)
#endif ()

#if(NOT SMCE_ROOT)
#
#endif()
