NAME=singr
R_VERSION=4.1.3

.PHONY: build push

build:
	singularity build $(NAME).sif $(NAME).def

push:
	singularity push -U $(NAME).sif library://cole-brokamp/default/$(NAME):$(R_VERSION)
	singularity push -U $(NAME).sif library://cole-brokamp/default/$(NAME):latest
