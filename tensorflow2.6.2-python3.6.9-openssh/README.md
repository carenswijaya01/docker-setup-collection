Refer to [this official repository](https://github.com/tensorflow/tensorflow/tree/v2.6.2). In this case, I want to build TensorFlow 2.6.2 (GPU) with Python 3.6.9.

Edit some package versions and add openssh-server (because I need it to be accessible through SSH). You can edit the SSH configuration in the Dockerfile.

You can run it by following these steps:

1. Prepare

   Ensure you have the NVIDIA driver installed on your system. You don't need NVIDIA CUDA on the host system because it runs in Docker, but you must set up the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

2. Build it (if you want to use ssh, set `your_password` section (line 69) in `./dockerfiles/gpu.Dockerfile`)

   ```bash
   docker build -f ./dockerfiles/gpu.Dockerfile -t tensorflow:2.6.2-py3.6.9 .`

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
