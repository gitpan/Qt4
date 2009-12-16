set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

include (MacroOptionalFindPackage)

FIND_PACKAGE(Perl REQUIRED)
FIND_PACKAGE (Qt4 REQUIRED)

add_definitions (${QT_DEFINITIONS}  -DHAVE_CONFIG_H=1)
include_directories (${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${QT_INCLUDES} )

include (FindPerlMore REQUIRED)
message(STATUS "Found site arch dir " ${PERL_SITE_ARCH_DIR})
SET(CUSTOM_PERL_SITE_ARCH_DIR ${PERL_SITE_ARCH_DIR} CACHE DIR "Custom installation directory for perl binary extension" )

add_subdirectory(lib)
add_subdirectory(src)
add_subdirectory(tools)
add_subdirectory(t)
