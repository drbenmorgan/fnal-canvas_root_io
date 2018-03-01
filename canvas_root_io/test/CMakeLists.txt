cet_enable_asserts()

# Make sure tests have correct environment settings.
include(CetTest)
# If you explicitly include CetTest in a subdirectory, you will need to
# re-initialize the test environment.
cet_test_env("FHICL_FILE_PATH=.")

if(ALT_CMAKE)
  # SIP workaround - here so that ROOT can find dictionaries etc
  cet_test_env("CETD_LIBRARY_PATH=$<TARGET_FILE_DIR:canvas_root_io>:$ENV{CETD_LIBRARY_PATH}")

  # workaround for UPS assumption about include dirs
  include_directories(${PROJECT_SOURCE_DIR})

  # .. and because ROOT doesn't yet set include dirs in its
  # targets
  include_directories(${ROOT_INCLUDE_DIRS})

  # Forward UPS vars/targets to imported ones
  add_library(cetlib INTERFACE)
  target_link_libraries(cetlib INTERFACE cetlib::cetlib)

  add_library(cetlib_except INTERFACE)
  target_link_libraries(cetlib_except INTERFACE cetlib_except::cetlib_except)

  add_library(canvas INTERFACE)
  target_link_libraries(canvas INTERFACE canvas::canvas)

  # - ROOT
  set(ROOT_CORE ROOT::Core)
  set(ROOT_HIST ROOT::Hist)
  set(ROOT_RIO  ROOT::RIO)
  set(ROOT_TREE ROOT::Tree)
endif()

# build Persistency libraries
add_subdirectory(Aggregate)
add_subdirectory(Utilities)
