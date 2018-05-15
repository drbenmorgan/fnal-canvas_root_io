include(CMakeParseArguments)
#include(CheckUpsVersion)

set(CHECK_CLASS_VERSION_EXE "${CMAKE_CURRENT_LIST_DIR}/checkClassVersion")

set(CCV_DEFAULT_RECURSIVE FALSE
  CACHE BOOL "Default setting for recursive checks by checkClassVersion (may be time-consuming)."
  )

# - Should also check that we can do "import ROOT" in case PYTHONPATH isn't set
#execute_process(COMMAND root-config --has-python
#  RESULT_VARIABLE CCV_ROOT_CONFIG_OK
#  OUTPUT_VARIABLE CCV_ENABLED
#  OUTPUT_STRIP_TRAILING_WHITESPACE
#)

#if(NOT CCV_ROOT_CONFIG_OK EQUAL 0)
#  message(FATAL_ERROR "Could not execute root-config successfully to interrogate configuration: exit code ${CCV_ROOT_CONFIG_OK}")
#endif()

#if(NOT CCV_ENABLED)
#  message("WARNING: The version of root against which we are building currently has not been built "
#    "with python support: ClassVersion checking is disabled."
#    )
#endif()

function(check_class_version)
  cmake_parse_arguments(CCV
    "UPDATE_IN_PLACE;RECURSIVE;NO_RECURSIVE"
    ""
    "LIBRARIES;REQUIRED_DICTIONARIES"
    ${ARGN}
    )

  # Assume that we will use ROOT's RootConfig
  if(NOT ROOT_FOUND)
    message(FATAL_ERROR "check_class_version: ROOT not found\n"
      "Ensure the project calls:\n"
      "find_package(ROOT REQUIRED)\n"
      "before using this function"
      )
  elseif(NOT ROOT_python_FOUND)
    message(FATAL_ERROR "check_class_version: PyROOT not found\n"
      "ROOT found at `${ROOT_DIR}`\n"
      "does not provide Python binding to ROOT required by check_class_version"
      )
  endif()
  # ROOT_LIBRARY_DIR *should* then contain the pyroot we need...

  if(CCV_LIBRARIES)
    message(FATAL_ERROR "LIBRARIES option not supported at this time: "
      "ensure your library is linked to any necessary libraries not already pulled in by ART.")
  endif()

  if(CCV_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unparsed arguments: ${CCV_UNPARSED_ARGUMENTS}")
  endif()

  if(CCV_UPDATE_IN_PLACE)
    set(CCV_EXTRA_ARGS ${CCV_EXTRA_ARGS} "-G")
  endif()

  if(CCV_RECURSIVE)
    set(CCV_EXTRA_ARGS ${CCV_EXTRA_ARGS} "--recursive")
  elseif(CCV_NO_RECURSIVE)
    set(CCV_EXTRA_ARGS ${CCV_EXTRA_ARGS} "--no-recursive")
  elseif(CCV_DEFAULT_RECURSIVE)
    set(CCV_EXTRA_ARGS ${CCV_EXTRA_ARGS} "--recursive")
  else()
    set(CCV_EXTRA_ARGS ${CCV_EXTRA_ARGS} "--no-recursive")
  endif()

  if(NOT dictname)
    message(FATAL_ERROR "CHECK_CLASS_VERSION must be called after BUILD_DICTIONARY.")
  endif()

  #if(CCV_ENABLED)
    # Add the check to the end of the dictionary building step.
    add_custom_command(OUTPUT ${dictname}_dict_checked
      # Assumes we're alongside... Might want target...
      # Note use of MF_PLUGIN_PATH. Needed with Messagefacility  >= 2.2.0 as this now
      # has globals for pluginfactories. These throw on construction unless dynamic
      # loader path is present. Use override variable here as it's highly unlikely
      # that we'll need the plugins for dictionary generation.
      COMMAND ${CMAKE_COMMAND} -E env "PYTHONPATH=${ROOT_LIBRARY_DIR}:${PYTHONPATH}" "MF_PLUGIN_PATH=${MF_PLUGIN_PATH}" ${CHECK_CLASS_VERSION_EXE} ${CCV_EXTRA_ARGS}
      # Might be $<TARGET_FILE:${dictname}_dict>?
      -l $<TARGET_PROPERTY:${dictname}_dict,LIBRARY_OUTPUT_DIRECTORY>/${CMAKE_SHARED_LIBRARY_PREFIX}${dictname}_dict
      -x ${CMAKE_CURRENT_SOURCE_DIR}/classes_def.xml
      -t ${dictname}_dict_checked
      COMMENT "Checking class versions for ROOT dictionary ${dictname}"
      # Following might just be $<TARGET_FILE:${dictname}_dict>?
      DEPENDS $<TARGET_PROPERTY:${dictname}_dict,LIBRARY_OUTPUT_DIRECTORY>/${CMAKE_SHARED_LIBRARY_PREFIX}${dictname}_dict${CMAKE_SHARED_LIBRARY_SUFFIX}
      )

    add_custom_target(checkClassVersion_${dictname} ALL
      DEPENDS ${dictname}_dict_checked)

    # All checkClassVersion invocations must wait until after *all*
    # dictionaries have been built.
    add_dependencies(checkClassVersion_${dictname} BuildDictionary_AllDicts)

    if(CCV_REQUIRED_DICTIONARIES)
      add_dependencies(${dictname}_dict ${CCV_REQUIRED_DICTIONARIES})
    endif()
    #endif()
endfunction()
