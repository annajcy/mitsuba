file(GLOB MTS_TEST_PLUGIN_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/test_*.cpp")

foreach(test_source IN LISTS MTS_TEST_PLUGIN_SOURCES)
    get_filename_component(test_name "${test_source}" NAME_WE)
    add_library(${test_name} MODULE ${test_source})

    target_link_libraries(${test_name}
        PRIVATE
            mitsuba_common_flags
            mitsuba_core
            mitsuba_render
            mitsuba_hw
    )

    if(test_name MATCHES "bidir")
        target_link_libraries(${test_name} PRIVATE mitsuba_bidir)
    endif()

    target_compile_definitions(${test_name} PRIVATE MTS_TESTCASE=1)
    set_target_properties(${test_name} PROPERTIES
        PREFIX ""
        LIBRARY_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
        RUNTIME_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
    )

    install(TARGETS ${test_name}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
        LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
    )
endforeach()
