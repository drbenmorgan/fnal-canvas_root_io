if(ALT_CMAKE)
  include(altCMakeLists.cmake)
  return()
endif()
cet_test(aggregate_th1_t USE_BOOST_UNIT
  LIBRARIES
  canvas
  cetlib_except
  ${ROOT_CORE}
  ${ROOT_HIST})
