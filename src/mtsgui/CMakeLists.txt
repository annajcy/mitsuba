set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

file(GLOB MTSGUI_CPP CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
file(GLOB MTSGUI_HEADERS CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
file(GLOB MTSGUI_UI CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.ui")
set(MTSGUI_RCC ${CMAKE_CURRENT_SOURCE_DIR}/resources.qrc)

if(APPLE)
    list(APPEND MTSGUI_CPP previewsettingsdlg_cocoa_impl.mm)
endif()

if(NOT APPLE)
    list(FILTER MTSGUI_CPP EXCLUDE REGEX ".*cocoa.*")
    list(FILTER MTSGUI_HEADERS EXCLUDE REGEX ".*cocoa.*")
endif()

add_executable(mtsgui
    ${MTSGUI_CPP}
    ${MTSGUI_HEADERS}
    ${MTSGUI_UI}
    ${MTSGUI_RCC}
)

target_include_directories(mtsgui PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(mtsgui
    PRIVATE
        mitsuba_common_flags
        mitsuba_core
        mitsuba_render
        mitsuba_hw
        mitsuba_bidir
        XercesC::XercesC
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::OpenGL
        Qt5::Xml
        Qt5::XmlPatterns
        Qt5::Network
)

if(TARGET mitsuba_converter_objects)
    target_sources(mtsgui PRIVATE $<TARGET_OBJECTS:mitsuba_converter_objects>)
    target_link_libraries(mtsgui PRIVATE ${COLLADA_LIBRARY})
endif()

if(APPLE)
    target_link_libraries(mtsgui PRIVATE "-framework Security" "-framework CoreFoundation")
endif()

install(TARGETS mtsgui
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
