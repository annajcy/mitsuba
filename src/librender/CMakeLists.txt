set(MTS_LIBRENDER_SOURCES
    bsdf.cpp
    film.cpp
    integrator.cpp
    emitter.cpp
    sensor.cpp
    skdtree.cpp
    medium.cpp
    renderjob.cpp
    imageproc.cpp
    rectwu.cpp
    renderproc.cpp
    imageblock.cpp
    particleproc.cpp
    renderqueue.cpp
    scene.cpp
    subsurface.cpp
    texture.cpp
    shape.cpp
    trimesh.cpp
    sampler.cpp
    util.cpp
    irrcache.cpp
    testcase.cpp
    photonmap.cpp
    gatherproc.cpp
    volume.cpp
    vpl.cpp
    shader.cpp
    scenehandler.cpp
    intersection.cpp
    common.cpp
    phase.cpp
    noise.cpp
    photon.cpp
)

add_library(mitsuba_render SHARED ${MTS_LIBRENDER_SOURCES})
set_target_properties(mitsuba_render PROPERTIES OUTPUT_NAME "mitsuba-render")

target_link_libraries(mitsuba_render
    PUBLIC
        mitsuba_common_flags
        mitsuba_core
    PRIVATE
        XercesC::XercesC
)

target_compile_definitions(mitsuba_render PRIVATE MTS_BUILD_MODULE=MTS_MODULE_RENDER)

install(TARGETS mitsuba_render
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
)
