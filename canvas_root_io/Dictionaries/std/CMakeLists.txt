if(ALT_CMAKE)
  art_dictionary(NO_DEFAULT_LIBRARIES NO_CHECK_CLASS_VERSION DICT_NAME_VAR _dictlib)
  # Use get_property to avoid nested genex expansion issue
  get_target_property(_rootmap_file ${_dictlib}_dict ROOTMAP_FILE)
  get_target_property(_pcm_file ${_dictlib}_dict PCM_FILE)
  install(TARGETS ${_dictlib}_dict
    EXPORT ${PROJECT_NAME}Targets
    DESTINATION ${CMAKE_INSTALL_LIBDIR})
  install(FILES ${_rootmap_file} ${_pcm_file}
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )
  return()
endif()

art_dictionary(NO_DEFAULT_LIBRARIES NO_CHECK_CLASS_VERSION)

install_source()
