# singr

A singularity image including:

- R
- geospatial system deps gdal, geos, and proj
- uber's h3 library
- aws cli

Versions of R are specified using the singularity image tags and GitHub releases, where:

- `4.0` refers to R Version `4.0.*` (e.g., 4.0.0 or 4.0.1, etc...)
- `latest` refers to the most recently pushed image

Note that different versions may use different base images for the Singularity container (e.g. `3.6` uses Ubuntu 18.04, but `4.0` uses Ubuntu 20.04).

## using with an R package on the CCHMC HPC

#### transfer to HPC

- use `renv::snapshot()` locally to snapshot project dependencies
- copy project folder to HPC home folder
    - *don't forget to copy all files, even dotfiles, `.Rprofile` generated by `renv` needs to be there to ensure private package library is used*
    - making sure that an `renv` project is present is important! without it, the R process in the container will try to use the host R package library (`.libPaths()`) and will cause all kinds of problems
    - an advantage of this is that the project library compiled specifically for the container OS will be stored locally, meaning that the packages will be already installed the next time the container is used
    - sidenote: if you want to run the container without an `renv` project setup, just setup an empty project first by running `renv::init()` from R on the host
- pull the the `.sif` file into your home folder (changing the tag number for a different version of R) with:
    - `singularity pull library://cole-brokamp/default/singr:4.0`
    - note that you can also use `latest` as the tag to get the most recent version
    - note that the name of the downloaded `.sif` file will be different depending on which tag was requested; we will use the file name `singr_latest.sif` assuming that the latest version was pulled from singularity hub
- setup any system environment variables if needed (e.g., `AWS_SECRET_ACCESS_KEY`)

#### start an interactive R session

Optionally, start a `tmux` or `screen` session from the HPC login node to keep your session persistently alive

Turn on the proxy so that the image can download and install R packages (`proxy_on` will prompt for CCHMC username and password). Note that as of June 2020, this is no longer required (and may in fact cause issues) because of changes IS implemented regarding how the HPC connects to the internet.

Change to the project directory and run:

```sh
bsub -Is -W 10:00 -n 16 -M 250000 -R "span[ptile=16]" "module load singularity; singularity run ~/singr_latest.sif"
```

This works by supplying the commands needed to run the singularity container and will drop you right into an interactive R prompt and automatically install the necessary version of `renv`

Next, bootstrap the library as defined in the lockfile by running `renv::restore()` within R

Double check resources available to R with:

```R
parallel::detectCores()
benchmarkme::get_ram()
benchmarkme::get_cup()
```

If you need access to a shell within the singularity container, run `singularity shell ~singr_latest.sif` instead of calling the container as an executable.

## notes 
- use `lshosts` to see an overview of available compute nodes and their specs
- tmux works from login node to attach to session started on a compute node (leave your job and come back later without having to find the ip address of the compute node)
- singularity imports all system environment variables (github/aws keys, etc)
- singularity automatically mounts `$HOME`, `$PWD`, and `/tmp`
- `renv::restore()` will install packages to project-specific library *but* these are actually symmlinks to `renv`'s cache folder within `$HOME`; this means that restoring a new project will link to this cache instead of reinstalling any R packages from source


