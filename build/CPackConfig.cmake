# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


set(CPACK_BUILD_SOURCE_DIRS "/Users/weiguo/Desktop/smce-gd-group;/Users/weiguo/Desktop/smce-gd-group/build")
set(CPACK_CMAKE_GENERATOR "Unix Makefiles")
set(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
set(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
set(CPACK_DEBIAN_COMPRESSION_TYPE "xz")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "/Users/weiguo/Desktop/smce-gd-group/debian/postinst;/Users/weiguo/Desktop/smce-gd-group/debian/postrm")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "An emulated environment for Arduino-based vehicles; primarily designed for use with the smartcar_shield library.")
set(CPACK_DEBIAN_PACKAGE_NAME "smce_gd")
set(CPACK_DEBIAN_PACKAGE_SECTION "embedded")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_FILE "/opt/homebrew/Cellar/cmake/3.21.2/share/cmake/Templates/CPack.GenericDescription.txt")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_SUMMARY "godot-smce built using CMake")
set(CPACK_DMG_BACKGROUND_IMAGE "/Users/weiguo/Desktop/smce-gd-group/project/media/images/icon.png")
set(CPACK_GENERATOR "DragNDrop")
set(CPACK_INSTALL_CMAKE_PROJECTS "/Users/weiguo/Desktop/smce-gd-group/build;godot-smce;ALL;/")
set(CPACK_INSTALL_PREFIX "/usr/local")
set(CPACK_MODULE_PATH "/Users/weiguo/Desktop/smce-gd-group/CMake/Modules")
set(CPACK_NSIS_DISPLAY_NAME "SMCE Godot")
set(CPACK_NSIS_INSTALLER_ICON_CODE "")
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
set(CPACK_NSIS_PACKAGE_NAME "SMCE Godot")
set(CPACK_NSIS_UNINSTALL_NAME "Uninstall")
set(CPACK_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk")
set(CPACK_OUTPUT_CONFIG_FILE "/Users/weiguo/Desktop/smce-gd-group/build/CPackConfig.cmake")
set(CPACK_PACKAGE_CONTACT "ItJustWorksTM <itjustworkstm@aerostun.dev>")
set(CPACK_PACKAGE_DEFAULT_LOCATION "/")
set(CPACK_PACKAGE_DESCRIPTION "This cross-platform C++ library provides its consumers the ability
to compile and execute Arduino sketches on a hosted environment, with bindings
to its virtual I/O ports to allow the host application to interact with its
child sketches.")
set(CPACK_PACKAGE_DESCRIPTION_FILE "/opt/homebrew/Cellar/cmake/3.21.2/share/cmake/Templates/CPack.GenericDescription.txt")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A library to run your Arduino code on a desktop OS")
set(CPACK_PACKAGE_FILE_NAME "smce_gd-1.3.2-Darwin-x86_64-AppleClang-GodotRelease")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/ItJustWorksTM/smce-gd")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "SMCE Godot")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "SMCE Godot")
set(CPACK_PACKAGE_NAME "SMCE Godot")
set(CPACK_PACKAGE_RELOCATABLE "true")
set(CPACK_PACKAGE_VENDOR "ItJustWorksTM")
set(CPACK_PACKAGE_VERSION "1.3.2")
set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "3")
set(CPACK_PACKAGE_VERSION_PATCH "2")
set(CPACK_RESOURCE_FILE_LICENSE "/Users/weiguo/Desktop/smce-gd-group/build/LICENSE.txt")
set(CPACK_RESOURCE_FILE_README "/opt/homebrew/Cellar/cmake/3.21.2/share/cmake/Templates/CPack.GenericDescription.txt")
set(CPACK_RESOURCE_FILE_WELCOME "/opt/homebrew/Cellar/cmake/3.21.2/share/cmake/Templates/CPack.GenericWelcome.txt")
set(CPACK_SET_DESTDIR "OFF")
set(CPACK_SOURCE_GENERATOR "TBZ2;TGZ;TXZ;TZ")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/Users/weiguo/Desktop/smce-gd-group/build/CPackSourceConfig.cmake")
set(CPACK_SOURCE_RPM "OFF")
set(CPACK_SOURCE_TBZ2 "ON")
set(CPACK_SOURCE_TGZ "ON")
set(CPACK_SOURCE_TXZ "ON")
set(CPACK_SOURCE_TZ "ON")
set(CPACK_SOURCE_ZIP "OFF")
set(CPACK_SYSTEM_NAME "Darwin-arm64-AppleClang")
set(CPACK_THREADS "1")
set(CPACK_TOPLEVEL_TAG "Darwin-arm64-AppleClang")
set(CPACK_WIX_PRODUCT_ICON "/Users/weiguo/Desktop/smce-gd-group/project/media/images/icon.png")
set(CPACK_WIX_ROOT_FEATURE_TITLE "SMCE Godot")
set(CPACK_WIX_SIZEOF_VOID_P "8")
set(CPACK_WIX_UPGRADE_GUID "0602a6db-61aa-4440-80f9-547cec5db5b9")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "/Users/weiguo/Desktop/smce-gd-group/build/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()
