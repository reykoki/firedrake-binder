FROM firedrakeproject/firedrake-notebooks:latest

ENV NB_USER jovyan
ENV NB_UID 1200
ENV HOME /home/${NB_USER}

RUN sudo adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
RUN sudo pip3 install --no-cache-dir notebook==5.*

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
