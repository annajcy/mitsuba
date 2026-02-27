add_library(mitsuba_converter_objects OBJECT
    collada.cpp
    obj.cpp
    converter.cpp
)

target_compile_definitions(mitsuba_converter_objects PRIVATE COLLADA_DOM_2_4)
target_include_directories(mitsuba_converter_objects PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${COLLADA_INCLUDE_DIR}
)

add_executable(mtsimport mtsimport.cpp $<TARGET_OBJECTS:mitsuba_converter_objects>)

target_link_libraries(mtsimport
    PRIVATE
        mitsuba_common_flags
        mitsuba_core
        mitsuba_render
        mitsuba_hw
        mitsuba_bidir
        XercesC::XercesC
        ${COLLADA_LIBRARY}
        ${MTS_PLATFORM_GL_DEPS}
)

if(APPLE)
    target_sources(mtsimport PRIVATE ${PROJECT_SOURCE_DIR}/src/mitsuba/darwin_stub.mm)
endif()

install(TARGETS mtsimport
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
