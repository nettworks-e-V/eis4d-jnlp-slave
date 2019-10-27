## Docker container with eis4d SDK
 
This is a docker implementation of eis4d jnlp slave for Jenkins.

For more information please refer to [Official website](http://www.eisfair.org/) 
or [Support forum](https://forum.nettworks.org)

### 1. Install docker

For installation please see [official documentation](https://docs.docker.com/install/linux/docker-ce/debian/).

### 2. Build/Use the Container

You now have two options: 
- Build from scratch or 
- Pull the ready-made image from DockerHub. 

#### 2a Image from Docker Hub

```shell
sudo docker pull nettworksevtooling/eis4d-jnlp-slave
```

#### 2b Build from scratch

##### Pull repo from github

```shell
sudo git clone https://github.com/nettworks-e-V/eis4d-jnlp-slave
cd eis4d-jnlp-slave
```

##### Build image

```shell
sudo docker build -t nettworksevtooling/eis4d-jnlp-slave:latest .
```

### 3. Starting docker container

```shell
sudo docker run \
    --name eis4d-jnlp-slave \
    -d \
    nettworksevtooling/eis4d-jnlp-slave:latest
```

#### 4. Available options

The container could be started with some of the following options. These list 
contains the default values, which could be overwritten on the docker run
command: 

 * JENKINS_URL=http://localhost
 * JENKINS_TUNNEL=
 * JENKINS_USERNAME=admin
 * JENKINS_PASSWORD=admin
 * EXECUTORS=1
 * DESCRIPTION=Swarm node with fli4l buildroot
 * LABELS=linux swarm fli4l-buildroot
 * NAME=generic-swarm-node

```shell
sudo docker run \
    --name eis4d-buildnode \
    -e "JENKINS_URL=https://jenkins.foobar.org" \
    -e "JENKINS_PASSWORD=123456" ...
```

#### 5. Jenkins behind reverse proxy

The option JENKINS_TUNNEL might be necessary if Jenkins is running behind
a reverse proxy as the jnlp connection could not be established in such a 
setup. You need to configure the following on Jenkins:
 
 * Configuration > Global Security > Agents
 * Set _TCP port for JNLP agents_ to _Static_
 * Enter a port number like _32775_
 * Save configuration

Assumed your Jenkins is available on https://jenkins.foobar.org, the host has 
the ip 10.20.30.40 and you configured the JNLP port 32775, you need to start 
the container with at least these options:

```shell
sudo docker run \
    --name eis4d-buildnode \
    -e "JENKINS_URL=https://jenkins.foobar.org" \
    -e "JENKINS_TUNNEL=10.20.30.40:32775" ...
```

### 6. Useful commands

Check running / stopped container:

```shell
sudo docker ps -a
```

Stop the container

```shell
sudo docker stop eis4d-jnlp-slave
```

Start the container

```shell
sudo docker start eis4d-jnlp-slave
```

Get logs from container

```shell
sudo docker logs -f eis4d-jnlp-slave
```

Open cmdline inside of container

```shell
sudo docker exec -i -t eis4d-jnlp-slave /bin/bash
```
