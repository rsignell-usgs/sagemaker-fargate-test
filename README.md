# SageMaker JupyterLab with FargateCluster

This is how I started JupyterLab using SageMaker, then launched a FargateCluster using [dask-cloudprovider](https://github.com/dask/dask-cloudprovider), following [Jacob Tomlinson's excellent blog post](https://medium.com/rapids-ai/getting-started-with-rapids-on-aws-ecs-using-dask-cloud-provider-b1adfdbc9c6e). 

First I created a SageMaker notebook instance using the AWS Console.  The default is `ml.t2.tiny` with 5GB EBS disk, but that wasn't enough memory or disk for me to create a custom conda environment with xarray, hvplot etc.   So I chose `ml.t3.large` with 40GB storage. 

Under SageMaker=>Notebook=>Git Repositories, I added this sagemaker-fargate-test repo so I would have my sample notebooks when I start my SageMaker JupyterLab. 

I then fired up the SageMaker instance JupyterLab, opened a terminal and typed:
```
conda activate base
conda update conda -y
conda env create -f ~/SageMaker/sagemaker-fargate-test/pangeo_env.yml
```
to update conda and create my custom `pangeo` environment. 

I then did `aws configure` and added my amazon keys.  This creates the `~/.aws` directory with credentials, which I copied to the persisted `~/SageMaker` directory.  This was a hacky way of giving my SageMaker Notebook instance the credentials to create the FargateCluster. 

I then created a SageMaker "Lifecycle configuration" script, which runs when the SageMaker notebook instance starts.   This script just copies the `.condarc` and the `.aws` credentials directory from persisted space to the $HOME directory.  This is the `lifecycle_start_notebook.sh` script in this repo. 

The last remaining step was to create a dask worker container for FargateCluster to run.  To create this container, I just [added some packages to the daskdev/dask container Dockerfile](https://github.com/rsignell-usgs/dask-docker/blob/pangeo/base/Dockerfile#L13-L19). 

The sample [Hurricane Ike Notebook then ran successfully](https://nbviewer.jupyter.org/gist/rsignell-usgs/097929d6587f2107c47b72032174e19c).  Here's a snapshot of the Dask dashboard:

![2020-01-23_14-48-49](https://user-images.githubusercontent.com/1872600/73019048-d13b6f00-3df0-11ea-9ee5-4f32f1d71598.png)
