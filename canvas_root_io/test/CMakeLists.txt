cet_enable_asserts()

# Make sure tests have correct environment settings.
include(CetTest)
# If you explicitly include CetTest in a subdirectory, you will need to
# re-initialize the test environment.
cet_test_env("FHICL_FILE_PATH=.")

# build Persistency libraries
add_subdirectory(Aggregate)
add_subdirectory(Utilities)
