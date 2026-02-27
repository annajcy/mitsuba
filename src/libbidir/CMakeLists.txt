set(MTS_LIBBIDIR_SOURCES
    common.cpp
    rsampler.cpp
    vertex.cpp
    edge.cpp
    path.cpp
    verification.cpp
    util.cpp
    pathsampler.cpp
    mut_bidir.cpp
    mut_lens.cpp
    mut_caustic.cpp
    mut_mchain.cpp
    manifold.cpp
    mut_manifold.cpp
)

add_library(mitsuba_bidir SHARED ${MTS_LIBBIDIR_SOURCES})
set_target_properties(mitsuba_bidir PROPERTIES OUTPUT_NAME "mitsuba-bidir")

target_link_libraries(mitsuba_bidir
    PUBLIC
        mitsuba_common_flags
        mitsuba_core
        mitsuba_render
)

target_compile_definitions(mitsuba_bidir PRIVATE MTS_BUILD_MODULE=MTS_MODULE_BIDIR)

install(TARGETS mitsuba_bidir
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
)
