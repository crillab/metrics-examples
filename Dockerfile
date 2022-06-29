FROM python:3.9.13-bullseye
RUN python3 -m pip install --no-cache-dir notebook jupyterlab
RUN pip install --no-cache-dir jupyterhub

ARG NB_USER=metrics
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

RUN pip install crillab-metrics
WORKDIR ${HOME}
