# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:stable

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"

# 2) change to root to install packages
USER root

#RUN apt-get -y install htop



### Clean up and update APT
RUN apt-get -y clean && apt-get -y update && apt-get -y upgrade


USER jovyan

### Install sagemath via condaforge method
### Per https://doc.sagemath.org/html/en/installation/conda.html#sec-installation-conda

### Install miniforge
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
RUN bash Miniforge3-$(uname)-$(uname -m).sh -b

### Install sagemath
RUN mamba create -n sage sage python=3.12

RUN mamba init

RUN bash --login -c 'echo begin-mamba-activate-sage; mamba activate sage; echo end-mamba-activate-sage; sage --version; exit 0'

#RUN source .bashrc
#RUN bash -c 'mamba activate sage'
#RUN bash -c 'sage --version'

#RUN mamba activate sage
#RUN sage --version

CMD ["mamba", "activate", "sage"]


# 3) install packages using notebook user
#USER jovyan

# RUN conda install -y scikit-learn

#RUN pip install --no-cache-dir networkx scipy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
