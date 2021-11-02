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

include (FetchContent)
message ("--- Downloading libsmce")
FetchContent_Declare (libsmce
        GIT_REPOSITORY "https://github.com/ItJustWorksTM/libSMCE"
        GIT_TAG v1.4.0
        GIT_SHALLOW On)
FetchContent_GetProperties (libsmce)
if (NOT libsmce_POPULATED)
    FetchContent_Populate (libsmce)
    message ("--- populated libsmce")
    file (READ "${libsmce_SOURCE_DIR}/CMakeLists.txt" libsmce_cmakelists)
    string (REPLACE "add_dependencies (SMCE ArdRtRes)" "add_dependencies (SMCE_static ArdRtRes)" libsmce_cmakelists "${libsmce_cmakelists}")
    file (WRITE "${libsmce_SOURCE_DIR}/CMakeLists.txt" "${libsmce_cmakelists}")

    set (SMCE_BUILD_SHARED Off CACHE INTERNAL "")
    set (SMCE_BUILD_STATIC On CACHE INTERNAL "")
    set (SMCE_CXXRT_LINKING "STATIC" CACHE INTERNAL "")
    set (SMCE_BOOST_LINKING "${PYSMCE_BOOST_LINKING}" CACHE INTERNAL "")
    add_subdirectory ("${libsmce_SOURCE_DIR}" "${libsmce_BINARY_DIR}" EXCLUDE_FROM_ALL)
endif ()

