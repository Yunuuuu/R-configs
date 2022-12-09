set_envpath <- function(env_var, ...) {
    if (any(lengths(list(...)) > 1L)) {
        stop("Element of length one is expected", call. = FALSE)
    }
    add_path <- file.path(...)
    add_path <- path.expand(add_path)
    env_var_value <- Sys.getenv(env_var, unset = "")
    if (identical(env_var_value, "")) {
        path <- add_path
    } else {
        path <- paste0(add_path, switch(.Platform$OS.type,
            windows = ";",
            unix = ":"
        ), env_var_value)
    }
    expr <- quote(Sys.setenv())
    expr[[env_var]] <- path
    eval(expr)
}
conda_env_dir <- "~/anaconda3/envs" # nolint

# pkg-specific PKG_CONFIG_PATH ---------------------------
# gert environment variable
# conda create -n libgit2 -c conda-forge libgit2
libgit2 <- file.path(conda_env_dir, "libgit2")
set_envpath("PKG_CONFIG_PATH", libgit2, "lib", "pkgconfig")
set_envpath("LD_LIBRARY_PATH", libgit2, "lib")

# textshaping environment variable
# harfbuzz
# conda create -n harfbuzz -c conda-forge harfbuzz
harfbuzz <- file.path(conda_env_dir, "harfbuzz")
set_envpath("PKG_CONFIG_PATH", harfbuzz, "lib", "pkgconfig")
# fribidi
# conda create -n fribidi -c conda-forge fribidi
fribidi <- file.path(conda_env_dir, "fribidi")
set_envpath("PKG_CONFIG_PATH", fribidi, "lib", "pkgconfig")

# R-release environment path -----------------------------
# conda create --name R-release -c conda-forge r-base git radian
conda_renv <- file.path(conda_env_dir, "R-release")
set_envpath("PKG_CONFIG_PATH", conda_renv, "lib", "pkgconfig")
