#TODO
cet_test_env("CETD_LIBRARY_PATH=$<TARGET_FILE_DIR:canvas_root_io>:$ENV{CETD_LIBRARY_PATH}")
include_directories(${PROJECT_SOURCE_DIR})
art_dictionary(NO_DEFAULT_LIBRARIES DICTIONARY_LIBRARIES cetlib::cetlib NO_INSTALL)

add_executable(TypeNameBranchName_t TypeNameBranchName_t.cc)
# Could just be "same directory behaviour" if .cc file #include rationalized
target_include_directories(TypeNameBranchName_t PRIVATE ${PROJECT_SOURCE_DIR})
target_link_libraries(TypeNameBranchName_t
  canvas::canvas
  cetlib::cetlib
  cetlib_except::cetlib_except
  )

#cet_make_exec(TypeNameBranchName_t
#  NO_INSTALL
#  LIBRARIES
#  canvas
#  cetlib
#  cetlib_except
#)

set(tnum 1)
foreach(types_file
    art_test_types.txt
    microboone_MC6.txt
    mu2e.txt
    lariat_r006037_sr0080.typetester.txt
    lbne_r001161_sr01_20150526T220054.art_typetester.txt
    )
  if (tnum LESS 10)
    set(tnum_text "0${tnum}")
  else()
    set(tnum_text "${tnum}")
  endif()
  cet_test(TypeNameBranchName_test_${tnum_text} HANDBUILT
    TEST_EXEC $<TARGET_FILE:TypeNameBranchName_t>
    TEST_ARGS ${CMAKE_CURRENT_SOURCE_DIR}/TypeNameBranchName_t/${types_file}
    )
  math(EXPR tnum "${tnum} + 1")
endforeach()

include_directories(${ROOT_INCLUDE_DIRS})
cet_test(RootClassMapping_t USE_BOOST_UNIT
  LIBRARIES
  canvas_root_io_test_Utilities_dict
  ${ROOT_Core_LIBRARY}
  ${ROOT_RIO_LIBRARY}
  ${ROOT_Tree_LIBRARY}
  #${ROOT_CINTEX}
  #${ROOT_MATHCORE}
  #${ROOT_CINT}
  #${ROOT_REFLEX}
  #${CMAKE_DL_LIBS}
  # When ROOT is fixed WILL_FAIL should be removed and the code in ASSNS
  # (and associated ioread rules) should be fixed accordingly.
  TEST_PROPERTIES WILL_FAIL true
  )

#TODO
# Dictionaries need to be in library path,
# not clear when in ROOT these need to be set.
cet_test(TypeTools_t USE_BOOST_UNIT
  LIBRARIES
  canvas_root_io
  canvas::canvas
  ${ROOT_Core_LIBRARY}
  #${ROOT_TREE}
  #${ROOT_HIST}
  #${ROOT_MATRIX}
  #${ROOT_MATHCORE}
  #${ROOT_RIO}
  #${ROOT_CORE}
  #${ROOT_CINT}
  #${ROOT_REFLEX}
  ${CMAKE_DL_LIBS}
  )

cet_test(TypeWithDict_t USE_BOOST_UNIT
  LIBRARIES
  canvas_root_io
  canvas::canvas
  ${ROOT_Core_LIBRARY}
  )
