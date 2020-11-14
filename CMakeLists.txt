project(argtable2)

# Create a shared library
if(WIN32)
  add_library(${PROJECT_NAME} SHARED                src/arg_dbl.c src/arg_end.c src/arg_file.c src/arg_int.c src/arg_uint.c src/arg_lit.c src/arg_rem.c               src/arg_str.c src/argtable2.c src/getopt.c src/getopt1.c src/argtable2.def)
else()
  add_library(${PROJECT_NAME} SHARED src/arg_date.c src/arg_dbl.c src/arg_end.c src/arg_file.c src/arg_int.c src/arg_uint.c src/arg_lit.c src/arg_rem.c src/arg_rex.c src/arg_str.c src/argtable2.c src/getopt.c src/getopt1.c)
endif()

# Ensure clients can find the includes
target_include_directories(${PROJECT_NAME} PUBLIC include)

# What to install
install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION bin
  ARCHIVE DESTINATION bin
)
install(
  DIRECTORY include/sheitmann DESTINATION include
)
