
# cmake will automatically order the library builds according to declared dependencies
add_subdirectory(Dictionaries)

# Recursion here just installs headers/sources
#add_subdirectory(Streamers)
#add_subdirectory(Utilities)

# - this should be higher....
find_package(Threads)
set(THREADS_PREFER_PTHREAD_FLAG TRUE)

add_library(canvas_root_io SHARED
  Streamers/AssnsStreamer.h
  Streamers/BranchDescriptionStreamer.cc
  Streamers/BranchDescriptionStreamer.h
  Streamers/CacheStreamers.cc
  Streamers/CacheStreamers.h
  Streamers/ProductIDStreamer.cc
  Streamers/ProductIDStreamer.h
  Streamers/RefCoreStreamer.cc
  Streamers/RefCoreStreamer.h
  Streamers/TransientStreamer.cc
  Streamers/TransientStreamer.h
  Streamers/setPtrVectorBaseStreamer.cc
  Streamers/setPtrVectorBaseStreamer.h
  Utilities/DictionaryChecker.cc
  Utilities/DictionaryChecker.h
  Utilities/TypeTools.cc
  Utilities/TypeTools.h
  Utilities/TypeWithDict.cc
  Utilities/TypeWithDict.h
  Utilities/getWrapperTIDs.cc
  Utilities/getWrapperTIDs.h
  )
target_include_directories(canvas_root_io
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    ${ROOT_INCLUDE_DIRS}
    )
target_link_libraries(canvas_root_io
  PUBLIC
    canvas::canvas
    cetlib::cetlib
    ${ROOT_Core_LIBRARY}
  PRIVATE
    messagefacility::MF_MessageLogger
    #TBB::TBB
  )

#-----------------------------------------------------------------------
# Testing, if required
if(BUILD_TESTING)
 add_subdirectory(test)
endif()

#-----------------------------------------------------------------------
# Install
install(TARGETS canvas_root_io
  EXPORT ${PROJECT_NAME}Targets
  DESTINATION ${CMAKE_INSTALL_LIBDIR}
  )
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/"
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}"
  FILES_MATCHING PATTERN "*.h" PATTERN "*.icc"
  PATTERN "test" EXCLUDE
  )

# Support files
#-----------------------------------------------------------------------
# Create exports file(s)
include(CMakePackageConfigHelpers)

# - Common to both trees
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion
  )

# - Build tree (EXPORT only for now, config file needs some thought,
#   dependent on the use of multiconfig)
export(
  EXPORT ${PROJECT_NAME}Targets
  NAMESPACE ${PROJECT_NAME}::
  FILE "${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake"
  )

# - Install tree
configure_package_config_file("${PROJECT_SOURCE_DIR}/${PROJECT_NAME}Config.cmake.in"
  "${PROJECT_BINARY_DIR}/InstallCMakeFiles/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  PATH_VARS CMAKE_INSTALL_INCLUDEDIR
  )

install(
  FILES
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    "${PROJECT_BINARY_DIR}/InstallCMakeFiles/${PROJECT_NAME}Config.cmake"
  DESTINATION
    "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
    )

install(
  EXPORT ${PROJECT_NAME}Targets
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
  )



