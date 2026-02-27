set(MTS_LIBCORE_SOURCES
    class.cpp
    object.cpp
    statistics.cpp
    thread.cpp
    brent.cpp
    logger.cpp
    appender.cpp
    formatter.cpp
    lock.cpp
    qmc.cpp
    random.cpp
    timer.cpp
    util.cpp
    properties.cpp
    half.cpp
    transform.cpp
    spectrum.cpp
    aabb.cpp
    stream.cpp
    math.cpp
    fstream.cpp
    plugin.cpp
    triangle.cpp
    bitmap.cpp
    fmtconv.cpp
    serialization.cpp
    sstream.cpp
    cstream.cpp
    mstream.cpp
    sched.cpp
    sched_remote.cpp
    sshstream.cpp
    zstream.cpp
    shvector.cpp
    fresolver.cpp
    rfilter.cpp
    quad.cpp
    mmap.cpp
    chisquare.cpp
    warp.cpp
    vmf.cpp
    tls.cpp
    ssemath.cpp
    spline.cpp
    track.cpp
)

if(APPLE)
    list(APPEND MTS_LIBCORE_SOURCES platform_darwin.mm)
elseif(WIN32)
    list(APPEND MTS_LIBCORE_SOURCES getopt.c)
endif()

add_library(mitsuba_core SHARED ${MTS_LIBCORE_SOURCES})
set_target_properties(mitsuba_core PROPERTIES OUTPUT_NAME "mitsuba-core")

target_link_libraries(mitsuba_core
    PUBLIC
        mitsuba_common_flags
        ${MTS_CORE_DEPENDENCIES}
)

target_compile_definitions(mitsuba_core PRIVATE MTS_BUILD_MODULE=MTS_MODULE_CORE)

if(WIN32)
    target_link_libraries(mitsuba_core PRIVATE psapi)
elseif(APPLE)
    target_link_libraries(mitsuba_core PRIVATE "-framework Cocoa")
endif()

install(TARGETS mitsuba_core
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
)
