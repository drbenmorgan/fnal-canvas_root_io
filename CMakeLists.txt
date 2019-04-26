# ======================================================================
#  art main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/art/ups/setup_for_development
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================


# use cmake 3.11 or later
cmake_minimum_required (VERSION 3.11...3.14 FATAL_ERROR)

project(canvas_root_io VERSION 1.03.03 LANGUAGES CXX)

# cetmodules contains our cmake modules
find_package(cetmodules 1.01.01 REQUIRED)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules)

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
  EXTRA_CXX_FLAGS -Wnon-virtual-dtor -Wdelete-non-virtual-dtor
  )

cet_report_compiler_flags()

find_package(hep_concurrency REQUIRED)
find_package(cetlib_except REQUIRED)
find_package(cetlib REQUIRED)
find_package(fhiclcpp REQUIRED)
find_package(messagefacility REQUIRED)
find_package(canvas REQUIRED)
find_package(CLHEP REQUIRED COMPONENTS Matrix Vector)
include_directories(${CLHEP_INCLUDE_DIRS})
find_package(ROOT REQUIRED COMPONENTS)
find_package(Boost REQUIRED COMPONENTS thread)

# art_dictionary
include(ArtDictionary)

# source
add_subdirectory(canvas_root_io)

# ups - table and config files
add_subdirectory(cmakeConfig)

# CMake modules
add_subdirectory(Modules)

# tools - e.g. migration scripts
add_subdirectory(tools)
