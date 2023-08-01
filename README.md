# singr

A Singularity image for running R, including geospatial system dependencies gdal, geos, proj, and udunits2 (from ppa:ubuntugis/ubuntugis-unstable).

## using

After installing or (`module load`-ing) [Singularity](https://sylabs.io/docs/), pull the image (~420MB) as a Singularity Image File (.sif) to the working directory:

```sh
singularity pull library://cole-brokamp/default/singr:4.3.0
```

Call the downloaded .sif to run the image, which here presents a bash shell where you can run `R`:

```sh
./singr_4.3.0.sif
```

## releases

The Singularity image tags correspond to version of R and `latest` refers to the most recently pushed image. Note that different versions may use different base images (e.g. `3.6` uses Ubuntu 18.04, `4.0` uses Ubuntu 20.04, `4.3` uses Ubuntu 22.04).

## CCHMC HPC

Optionally, start a `tmux` or `screen` session from the HPC login node to keep your session persistently alive

Change to the project directory and run:

```sh
bsub -Is -W 10:00 -n 16 -M 250000 -R "span[ptile=16]" "module load singularity; singularity run ~/singr_latest.sif"
```

This works by supplying the commands needed to run the singularity container. Once the job is running, you will be presented with an interactive shell where you can run `R`

Double check resources available to R with:

```R
parallel::detectCores()
benchmarkme::get_ram()
benchmarkme::get_cpu()
```

## notes 

- use `lshosts` to see an overview of available compute nodes and their specs
- tmux works from login node to attach to session started on a compute node (leave your job and come back later without having to find the ip address of the compute node)
- singularity imports all system environment variables (github/aws keys, etc)
- singularity automatically mounts `$HOME`, `$PWD`, and `/tmp`


