NAME=singr
R_VERSION=3.6.2

.PHONY: build push

build:
	singularity build $(NAME).def $(NAME).sif

push:
  singularity sign $(NAME).sif
	singularity push $(NAME).sif library://cole-brokamp/default/$(NAME):$(R_VERSION)
	singularity push $(NAME).sif library://cole-brokamp/default/$(NAME):latest
