set(MTS_APP_LINK_LIBS
    mitsuba_common_flags
    mitsuba_core
    mitsuba_render
    mitsuba_hw
    mitsuba_bidir
    XercesC::XercesC
    ${MTS_PLATFORM_GL_DEPS}
)

if(APPLE)
    add_library(mitsuba_darwin_stub OBJECT darwin_stub.mm)
endif()

add_executable(mtsutil mtsutil.cpp)
if(APPLE)
    target_sources(mtsutil PRIVATE $<TARGET_OBJECTS:mitsuba_darwin_stub>)
endif()
target_link_libraries(mtsutil PRIVATE ${MTS_APP_LINK_LIBS})

add_executable(mtssrv mtssrv.cpp)
target_link_libraries(mtssrv PRIVATE ${MTS_APP_LINK_LIBS})

add_executable(mitsuba mitsuba.cpp)
target_link_libraries(mitsuba PRIVATE ${MTS_APP_LINK_LIBS})

install(TARGETS mtsutil mtssrv mitsuba
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
