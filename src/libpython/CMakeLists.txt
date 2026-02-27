set(MTS_PYTHON_SOURCES
    core.cpp
    render.cpp
)

add_library(mitsuba_python MODULE ${MTS_PYTHON_SOURCES})
set_target_properties(mitsuba_python PROPERTIES
    PREFIX ""
    OUTPUT_NAME "mitsuba_python${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}"
    LIBRARY_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${MTS_PLUGIN_OUTPUT_DIR}"
)

target_link_libraries(mitsuba_python
    PRIVATE
        mitsuba_common_flags
        mitsuba_core
        mitsuba_render
        mitsuba_hw
        mitsuba_bidir
        XercesC::XercesC
        Python3::Python
)

target_compile_definitions(mitsuba_python PRIVATE MTS_BUILD_MODULE=MTS_MODULE_PYTHON)

if(NOT WIN32)
    target_compile_options(mitsuba_python PRIVATE -fno-strict-aliasing)
endif()

if(APPLE)
    target_link_options(mitsuba_python PRIVATE
        -Wl,-rpath,@loader_path/../../Contents/Frameworks
        -undefined dynamic_lookup
    )
elseif(UNIX)
    target_link_options(mitsuba_python PRIVATE -Wl,-rpath,'$ORIGIN/../..')
endif()

install(TARGETS mitsuba_python
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
    LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}/plugins
)
