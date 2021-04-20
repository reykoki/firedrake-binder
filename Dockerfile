# DockerFile for a firedrake + jupyter container

FROM firedrakeproject/firedrake

# This DockerFile is looked after by
#MAINTAINER David Ham <david.ham@imperial.ac.uk>

USER firedrake

WORKDIR /home/firedrake
# Install an iPython kernel for firedrake
RUN bash -c ". /home/firedrake/firedrake/bin/activate && pip install jupyterhub ipykernel notebook ipywidgets mpltools nbformat nbconvert"
RUN bash -c ". /home/firedrake/firedrake/bin/activate && jupyter nbextension enable --py widgetsnbextension --sys-prefix"

# Remove the install log.
RUN bash -c "rm firedrake-*"
# Strip the output from the notebooks.
RUN bash -c '. /home/firedrake/firedrake/bin/activate && for file in firedrake/src/firedrake/docs/notebooks/*.ipynb; do jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; done'

# Now do the same for thetis.
RUN bash -c '. /home/firedrake/firedrake/bin/activate && for file in thetis/*.ipynb; do jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; done'

# Environment required for Azure deployments.
ENV OMPI_MCA_btl=tcp,self
ENV PATH=/home/firedrake/firedrake/bin:$PATH

CMD /home/firedrake/firedrake/bin/jupyter notebook --ip 0.0.0.0 --no-browser --allow-root
