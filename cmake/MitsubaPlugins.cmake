function(mts_add_plugin target_name)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs SOURCES LIBS INCLUDES DEFINITIONS)
    cmake_parse_arguments(MTS_PLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(MTS_PLUGIN_SOURCES)
        set(_mts_sources ${MTS_PLUGIN_SOURCES})
    else()
        set(_mts_sources ${MTS_PLUGIN_UNPARSED_ARGUMENTS})
    endif()

    add_library(${target_name} MODULE ${_mts_sources})
    target_link_libraries(${target_name}
        PRIVATE
            mitsuba_common_flags
            mitsuba_core
            mitsuba_render
            mitsuba_hw
    )

    if(MTS_PLUGIN_LIBS)
        target_link_libraries(${target_name} PRIVATE ${MTS_PLUGIN_LIBS})
    endif()

    target_include_directories(${target_name} PRIVATE ${PROJECT_SOURCE_DIR}/include)

    if(MTS_PLUGIN_INCLUDES)
        target_include_directories(${target_name} PRIVATE ${MTS_PLUGIN_INCLUDES})
    endif()

    if(MTS_PLUGIN_DEFINITIONS)
        target_compile_definitions(${target_name} PRIVATE ${MTS_PLUGIN_DEFINITIONS})
    endif()

    set_target_properties(${target_name} PROPERTIES
        PREFIX ""
        LIBRARY_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
        RUNTIME_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
    )

    install(TARGETS ${target_name}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
        LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
    )
endfunction()

function(mts_add_bidir_plugin target_name)
    mts_add_plugin(${target_name} ${ARGN})
    target_link_libraries(${target_name} PRIVATE mitsuba_bidir)
endfunction()
