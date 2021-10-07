# Install script for directory: /Users/weiguo/Desktop/smce-gd-group

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Library/Developer/CommandLineTools/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  
        execute_process (COMMAND "/Applications/godot.app/Contents/MacOS/Godot" --no-window --export "macos" "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot"
                         WORKING_DIRECTORY "/Users/weiguo/Desktop/smce-gd-group/project")
        if (NOT EXISTS "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot")
            message (FATAL_ERROR "Godot export failure")
        endif ()
        execute_process (COMMAND "/opt/homebrew/Cellar/cmake/3.21.2/bin/cmake" -E tar xf "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot"
                         WORKING_DIRECTORY "/Users/weiguo/Desktop/smce-gd-group/build/export")
        execute_process (COMMAND defaults write "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot.app/Contents/Info.plist" LSEnvironment -dict PATH "/bin:/usr/bin:/usr/local/bin:/opt/homebrew/bin:")
    
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot.app/Contents/Frameworks/libSMCE.1.dylib")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot.app/Contents/Frameworks" TYPE FILE FILES "/Users/weiguo/Desktop/smce-gd-group/build/libSMCE.1.dylib")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  
        file (INSTALL "/Users/weiguo/Desktop/smce-gd-group/build/export/SMCE-Godot.app" DESTINATION "${CMAKE_INSTALL_PREFIX}" USE_SOURCE_PERMISSIONS)
    
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/weiguo/Desktop/smce-gd-group/build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
