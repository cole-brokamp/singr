# singr

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4044)

A singularity image including:

- R version 3.6.2
- geospatial system deps gdal and geos
- aws cli

## using with an R package on the CCHMC HPC

#### transfer to HPC

- use `renv::snapshot()` locally to snapshot project dependencies
- copy project folder to HPC home folder (*don't forget to copy all files, even dotfiles, `.Rprofile` generated by `renv` needs to be there to ensure private package library is used*)
- make sure `singr.sif` is present in home folder
    - either copy from a build of https://github.com/cole-brokamp/singr
    - or pull from singularity hub with `...`
- setup any system environment variables if needed (e.g., `AWS_SECRET_ACCESS_KEY`)

#### start an interactive R session

change to the project directory and run:

```sh
# request interactive job:
bsub -Is -W 10:00 -n 16 -M 250000 -R "span[ptile=16]" /bin/bash

# optional: use tmux to create a detachable prompt

# turn on internet by interactively entering cchmc username and password with:
proxy_on

# start singularity image
module load singularity/3.1.0
singularity run ~/singr.sif
```

this will open up an interactive R prompt and automatically install the necessary version of `renv`

next, bootstrap the library as defined in the lockfile by running `renv::restore()` within R

check resources available to R with:

```R
parallel::detectCores()
benchmarkme::get_ram()
benchmarkme::get_cup()
```

#### run a batch R job

...

## notes

- tmux works from login node to attach to session started on a compute node (leave your job and come back later without having to find the ip address of the compute node)
- singularity imports all system environment variables (github/aws keys, etc)
- singularity automatically mounts `$HOME`, `$PWD`, and `/tmp`
- `renv::restore()` will install packages to project-specific library *but* these are actually symmlinks to `renv`'s cache folder within `$HOME`; this means that restoring a new project will link to this cache instead of reinstalling any R packages from source


