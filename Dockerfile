FROM continuumio/miniconda3:4.7.12

RUN conda install --yes \
    -c conda-forge \
    python=3.6.10 \
    python-blosc \
    cytoolz \
    dask==2.14.0 \
    msgpack-python=1.0.0 \
    lz4 \
    nomkl \
    numpy==1.18.1 \
    pandas==1.0.3 \
    tini==0.18.0 \
    xarray \
    netcdf4 \
    zarr \
    fsspec \
    pip \
    s3fs \
    h5py \
    h5netcdf \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
