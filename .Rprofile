# OS-specific Renviron file
# Environment variables should be read firstly before sourcing Rprofile
if (file.exists("~/.Renviron_local")) readRenviron("~/.Renviron_local")

# create R_LIBS_USER path when non-exist
local({
    lib_path <- Sys.getenv("R_LIBS_USER", unset = "", names = FALSE)
    if (nzchar(lib_path)) {
        lib_paths <- strsplit(lib_path,
            if (.Platform$OS.type == "windows") {
                ";"
            } else {
                ":"
            },
            fixed = TRUE
        )[[1]]
        lib_paths <- path.expand(lib_paths)
        lib_paths <- lib_paths[!dir.exists(lib_paths)]
        if (length(lib_paths)) {
            lapply(lib_paths, function(x) {
                warning(
                    "dir `R_LIBS_USER` ", x,
                    " doesn't exist, try to create it.",
                    call. = FALSE
                )
                create_lib_paths <- tryCatch(
                    dir.create(x, recursive = TRUE),
                    error = function(e) {
                        warning("Error when creating dir ", x, ".",
                            call. = FALSE
                        )
                        return(FALSE)
                    }
                )
                if (create_lib_paths) {
                    message("Create dir ", x, " Successfully.\n")
                }
            })
        }
    }
})

# setting RStudio Package Manager
local({
    # paste(R.version$year, R.version$month, R.version$day, sep = "-")
    # set a CRAN mirror
    r <- getOption("repos")
    # repos.date <- "latest"
    # r["CRAN"] <- paste0("https://packagemanager.rstudio.com/cran/",
    # repos.date)
    r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
    options(repos = r)

    # cat("\nDefault CRAN mirror snapshot taken on ", repos.date, ".", sep = "")
    # cat("\n", "See: https://packagemanager.rstudio.com.", sep = "")
    cat("\nDefault CRAN mirror taken on: ", r["CRAN"], ".", sep = "")
    cat("\n\n")
})

# set maximal print lines
options(max.print = 500)

# warn when a vector is extended
# options(check.bounds = TRUE) # this'll cause too many warnings when start up

# warns if partial matching is used in argument matching
options(warnPartialMatchArgs = TRUE)

# warns if partial matching is used for extraction by `$`
options(warnPartialMatchDollar = TRUE)

# set console width and languageserver formatting style -----------------------

local({
    if (interactive()) {
        if (nzchar(Sys.getenv("RSTUDIO", "", names = FALSE))) {
            # ** for RStudio
            options(prompt = "\u001b[34;1m[R]\u001b[36;1m>\u001b[0m ")
            options(
                styler.addins_style_transformer = "styler::tidyverse_style(indent_by = 4L, math_token_spacing = styler::specify_math_token_spacing(zero = c(\"'/'\", \"'^'\")))" # nolint
            )
        } else if (nzchar(Sys.getenv("RADIAN_VERSION", "", names = FALSE))) {
            # ** for radian
            options(prompt = "\u001b[34;1m[R]\u001b[33;1m>\u001b[0m ")

            # Set locale to utf8
            is_uft8_support <- grepl(
                "UTF-8|utf8", Sys.getenv("LANG"),
                ignore.case = TRUE, perl = TRUE
            ) &&
                utils::compareVersion(
                    paste(R.version$major, R.version$minor, sep = "."),
                    "4.2.0"
                ) >= 0L
            if (is_uft8_support) {
                suppressWarnings(Sys.setlocale("LC_ALL", Sys.getenv("LANG")))
            }
        } else {
            # ** for raw Rterm
            options(prompt = "\u001b[34;1m[R]\u001b[36;1m>\u001b[0m ")

            # options(width = as.integer(system2("tput", "cols", stdout = TRUE)))
            if (requireNamespace("cli", quietly = TRUE)) {
                options(width = cli::console_width())
                options(setWidthOnResize = TRUE)
            } else {
                message(
                    "Install package `cli` to set width based on current console width!",
                    appendLF = TRUE
                )
            }

            # automatically save history
            # .Last <- function() if (interactive()) try(savehistory(".Rhistory"))
        }

        if (Sys.getenv("TERM_PROGRAM", names = FALSE) == "vscode") {
            # adjust languageserver formatting style
            options(languageserver.formatting_style = function(options) {
                styler::tidyverse_style(
                    indent_by = options$tabSize,
                    math_token_spacing = styler::specify_math_token_spacing(
                        zero = c("'/'", "'^'")
                    )
                )
            })
            # SVG in httpgd webpage - browser viewer
            # if (isTRUE(getOption("vsc.use_httpgd", FALSE))) {
            #     if (requireNamespace("httpgd", quietly = TRUE)) {
            #         options(device = function(...) {
            #             httpgd::hgd(silent = TRUE)
            #             .vsc$request_browser(
            #                 url = httpgd::hgd_url(),
            #                 title = "R Plot",
            #                 viewer = getOption("vsc.plot", "Two")
            #             )
            #         })
            #     } else {
            #         message("Install package `httpgd` to use vscode-R with httpgd!")
            #     }
            # }
        }

        if (Sys.getenv("TERM_PROGRAM", names = FALSE) == "tmux") {
            # Using self-managed R terminals
            source(file.path(
                Sys.getenv(
                    if (.Platform$OS.type == "windows") {
                        "USERPROFILE"
                    } else {
                        "HOME"
                    }
                ),
                ".vscode-R", "init.R"
            ))
        }

        # enable progress bar
        if (requireNamespace("progressr", quietly = TRUE)) {
            ## Enable global progression updates
            if (getRversion() >= 4) progressr::handlers(global = TRUE)

            ## In RStudio Console, or not?
            if (nzchar(Sys.getenv("RSTUDIO", "", names = FALSE))) {
                options(progressr.handlers = progressr::handler_rstudio)
            } else {
                options(progressr.handlers = progressr::handler_progress)
            }
        }
        # suppressMessages(prettycode::prettycode())
    }
})

# OS-specific Rprofile file
# local Rprofile should run after user's Rprofile
if (file.exists("~/.Rprofile_local")) source("~/.Rprofile_local")
