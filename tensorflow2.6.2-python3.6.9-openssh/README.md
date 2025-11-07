Refer to [this official repository](https://github.com/tensorflow/tensorflow/tree/v2.6.2). In this case, I want to build TensorFlow 2.6.2 (GPU) with Python 3.6.9.

Optional: Add Open SSH Support
Edit some package versions and add openssh-server (because I need it to be accessible through SSH). You can edit the SSH configuration in the Dockerfile.

Optional: Add CUDA 10.0 Support
CUDA 10.0 installation is included in the Dockerfile (lines 77-97, and 109). If you don't need CUDA 10.0, simply comment out those lines.
If you do need CUDA 10.0, make sure to download the following files and place them in the project's root directory:

```
.
├── dockerfiles/
│ └── gpu.Dockerfile
├── installers/
│ ├── cuda_10.0.130_410.48_linux.run
│ ├── cuda_10.0.130.1_linux.run
│ └── cudnn-10.0-linux-x64-v7.6.5.32.tgz
```

Download link:

- [cuda_10.0.130_410.48_linux.run](https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux) (you need to rename it after download, add .run extension)
- [cuda_10.0.130.1_linux.run](http://developer.download.nvidia.com/compute/cuda/10.0/Prod/patches/1/cuda_10.0.130.1_linux.run)
- [cudnn-10.0-linux-x64-v7.6.5.32.tgz](https://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.0-linux-x64-v7.6.5.32.tgz)

You can run it by following these steps:

1. Prepare

   Ensure you have the NVIDIA driver installed on your system. You don't need NVIDIA CUDA on the host system because it runs in Docker, but you must set up the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

2. Build it (if you want to use ssh, set `your_password` section (line 73) in `./dockerfiles/gpu.Dockerfile`)

   ```bash
   docker build -f ./dockerfiles/gpu.Dockerfile -t tensorflow:2.6.2-py3.6.9 .

   ```

3. Run it (docker cli version)

   ```bash
   docker run -it --rm --runtime=nvidia --gpus all tensorflow:2.6.2-py3.6.9 python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
   ```

Normally, it should detect your GPU.

You can run it using docker-compose.yml.

```bash
docker compose up -d
```

Define your ssh port (for the container, not your host) in the `command` section. Access it by:

```bash
ssh root@your_ip -p 2222
```

If you don't want to use SSH, simply set the `command: 'tail -f /dev/null'`.

If you want to use CUDA 10.0, add the following lines to your `/root/.bashrc`

```
export PATH=/usr/local/cuda-10.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64:$LD_LIBRARY_PATH
```

After adding these lines, apply the changes by running:

```
source /root/.bashrc
```

This will update the environment variables to use CUDA 10.0 for the current session.
