set(MTS_LIBHW_SOURCES
    session.cpp
    device.cpp
    gputexture.cpp
    gpugeometry.cpp
    gpuprogram.cpp
    renderer.cpp
    glrenderer.cpp
    glprogram.cpp
    glgeometry.cpp
    gltexture.cpp
    gpusync.cpp
    glsync.cpp
    vpl.cpp
    font.cpp
    viewer.cpp
    basicshader.cpp
    shadow.cpp
)

if(WIN32)
    list(APPEND MTS_LIBHW_SOURCES
        wglsession.cpp
        wgldevice.cpp
        wglrenderer.cpp
    )
elseif(APPLE)
    list(APPEND MTS_LIBHW_SOURCES
        nsglsession.mm
        nsgldevice.mm
        nsglrenderer.mm
    )
else()
    list(APPEND MTS_LIBHW_SOURCES
        x11session.cpp
        x11device.cpp
        glxdevice.cpp
        glxrenderer.cpp
    )
endif()

add_library(mitsuba_hw SHARED ${MTS_LIBHW_SOURCES})
set_target_properties(mitsuba_hw PROPERTIES OUTPUT_NAME "mitsuba-hw")

target_link_libraries(mitsuba_hw
    PUBLIC
        mitsuba_common_flags
        mitsuba_core
        mitsuba_render
    PRIVATE
        ${MTS_PLATFORM_GL_DEPS}
)

target_compile_definitions(mitsuba_hw PRIVATE MTS_BUILD_MODULE=MTS_MODULE_HW)

if(UNIX AND NOT APPLE)
    target_compile_definitions(mitsuba_hw PRIVATE GLEW_MX)
endif()

install(TARGETS mitsuba_hw
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
)
