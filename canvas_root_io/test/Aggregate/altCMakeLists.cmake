include_directories(${PROJECT_SOURCE_DIR})
include_directories(${ROOT_INCLUDE_DIRS})
cet_test(aggregate_th1_t USE_BOOST_UNIT
  LIBRARIES
  canvas::canvas
  cetlib_except::cetlib_except
  ${ROOT_Core_LIBRARY}
  ${ROOT_Hist_LIBRARY})
