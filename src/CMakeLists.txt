
add_executable(metalinfo
  main.mm
)

target_compile_options(metalinfo PUBLIC "-fobjc-arc")

target_link_libraries(metalinfo
  PUBLIC
  "-framework Foundation"
  "-framework Metal"
)

target_compile_options(metalinfo PRIVATE "-Wno-deprecated-declarations")
