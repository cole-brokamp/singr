NAME=singr
R_VERSION=4.3.0

.PHONY: build push

build:
	singularity build --remote $(NAME).sif $(NAME).def

push:
	singularity push -U $(NAME).sif library://cole-brokamp/default/$(NAME):$(R_VERSION)
	singularity push -U $(NAME).sif library://cole-brokamp/default/$(NAME):latest
