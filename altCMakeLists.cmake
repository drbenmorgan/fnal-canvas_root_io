# - Canvas top level build
# Project setup
cmake_minimum_required(VERSION 3.3.0)
project(canvas_root_io VERSION 1.4.2)

# - Cetbuildtools, version2
find_package(cetbuildtools2 0.2.0 REQUIRED)
list(INSERT CMAKE_MODULE_PATH 0 ${cetbuildtools2_MODULE_PATH})
set(CET_COMPILER_CXX_STANDARD_MINIMUM 14)
include(CetInstallDirs)
include(CetCMakeSettings)
include(CetCompilerSettings)

# - Our our modules
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_LIST_DIR}/Modules/AltCMake)

#-----------------------------------------------------------------------
# Required Third Party Packages
find_package(canvas REQUIRED)
find_package(cetlib_except REQUIRED)
find_package(cetlib REQUIRED)
find_package(fhiclcpp REQUIRED)
find_package(messagefacility REQUIRED)

set(Boost_NO_BOOST_CMAKE ON)
# - Ensure we can refind Boost and extra components we need
find_package(Boost 1.60.0
  REQUIRED
    date_time
    unit_test_framework
    program_options
    thread
  )

# Only AppleClang for now - also need check for clang+libstdc++
find_package(ROOT 6.12.4 REQUIRED Core)

find_package(TBB REQUIRED)

# CLHEP supplies a CMake project config...
find_package(CLHEP 2.3.2.2 REQUIRED)

# art_dictionary
include(ArtDictionary)

# source
add_subdirectory(canvas_root_io)

# ups - table and config files
#add_subdirectory(ups)

# CMake modules
#add_subdirectory(Modules)
install(DIRECTORY Modules/AltCMake/
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}/Modules
  PATTERN "checkClassVersion"
  PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
                     GROUP_EXECUTE GROUP_READ
  )

# tools - e.g. migration scripts
#add_subdirectory(tools)

# packaging utility
#include(UseCPack)
