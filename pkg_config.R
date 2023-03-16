add_envpath <- function(env_var, ...) {
    if (any(lengths(list(...)) > 1L)) {
        stop("Element of length one is expected", call. = FALSE)
    }
    add_path <- file.path(...)
    add_path <- path.expand(add_path)
    env_var_value <- Sys.getenv(env_var, unset = "", names = FALSE)
    if (nzchar(env_var_value)) {
        path <- paste0(
            add_path,
            if (.Platform$OS.type == "windows") {
                ";"
            } else {
                ":"
            },
            env_var_value
        )
    } else {
        path <- add_path
    }
    expr <- quote(Sys.setenv())
    expr[[env_var]] <- path
    eval(expr)
}
conda_env_dir <- "~/anaconda3/envs" # nolint

# pkg-specific PKG_CONFIG_PATH ---------------------------
# these packages are not compitable with current conda R environment, install
# this package in another conda environment and add the corresponding
# PKG_CONFIG_PATH

# gert environment variable
# conda create -n libgit2 -c conda-forge libgit2
libgit2 <- file.path(conda_env_dir, "libgit2")
add_envpath("PKG_CONFIG_PATH", libgit2, "lib", "pkgconfig")
add_envpath("LD_LIBRARY_PATH", libgit2, "lib")

# textshaping environment variable
# harfbuzz
# conda create -n harfbuzz -c conda-forge harfbuzz
harfbuzz <- file.path(conda_env_dir, "harfbuzz")
add_envpath("PKG_CONFIG_PATH", harfbuzz, "lib", "pkgconfig")
# fribidi
# conda create -n fribidi -c conda-forge fribidi
fribidi <- file.path(conda_env_dir, "fribidi")
add_envpath("PKG_CONFIG_PATH", fribidi, "lib", "pkgconfig")

# Some specific packages
# For udunits2 and units we neeed install udunits2
# https://github.com/r-quantities/units/issues/1#issuecomment-330435512
# https://github.com/pacificclimate/Rudunits2/issues/20#issuecomment-343684979
# conda create -n udunits2 -c conda-forge udunits2
udunits2 <- file.path(conda_env_dir, "udunits2")
add_envpath("PKG_CONFIG_PATH", udunits2, "lib", "pkgconfig")
# add_envpath("LD_LIBRARY_PATH", udunits2, "lib")
# dyn.load(file.path(udunits2, "lib", "libudunits2.so.0"))
# install.packages("udunits2",
#     type = "source",
#     configure.args = c(
#         paste0(
#             c("--with-udunits2-lib", "--with-udunits2-include"),
#             "=",
#             path.expand("~/miniconda3/envs/udunits2/"), # nolint
#             c("lib", "include")
#         )
#     )
# )

# in .bashrc
# export R_LD_LIBRARY_PATH=${R_LD_LIBRARY_PATH}:~/miniconda3/envs/udunits2/lib

# R-release environment path -----------------------------
# conda create --name R-release -c conda-forge r-base radian gcc
conda_renv <- file.path(conda_env_dir, "R-release")
add_envpath("PKG_CONFIG_PATH", conda_renv, "lib", "pkgconfig")
