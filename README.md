# Yggdrasil
New pentesting Framework

## Context
Yggdrasil is a tool or a framework for pentesting, allowing to provide a complete environment to conduct a pentest or a ctf.  
This environment is based on Docker and gvisor.  
Far from having the efficiency and engineering of exegol https://github.com/ThePorgs/Exegol (thePorgs) shout-out to them, I just decided to remake a similar environment by integrating a sandbox technology, in order to make the isolation and security of the docker available scalable. All this management is done with the docker-compose.yml

## Technologies  

### Docker and docker-compose what is it ?  

Docker is a lightweight and portable platform for packaging and deploying applications in containers, while Docker Compose is a tool for managing multi-container applications using declarative configuration in a YAML file.   
Together, Docker and Docker Compose provide a powerful and convenient way to create, deploy and manage applications in container environments.  

### Gvisor what is it ?   

gVisor is a sandboxing technology for containers that provides enhanced isolation and increased security by running applications in a more controlled and minimalist environment.   

It is an intermediary between the host core and the containers, providing an additional layer of isolation.   

Unlike other lightweight virtualization solutions, gVisor does not use virtual machines or full guest kernels. Instead, it implements its own minimal kernel and provides Linux system call emulation for applications running in containers.  

## Prerequisites  

To set up the environment it is necessary to install git and curl.  
the way to do it will depend completely on your "OS"  

Arch... (Pacman package management)

```shell
pacman -Sy && pacman -S curl git -y
```

Debian, ubuntu... (APT package management)

```shell
apt update && apt install curl git -y
```

## Installation  

#### In wonderful world  
<p align="center">
  <img src="./gifs/wonderful-world.gif" alt="animated" />
</p>  

One line install:  
```shell
git clone https://github.com/Oni-kuki/Yggdrasil && cd Yggdrasil && sudo chmod 700 install.sh && ./install.sh
```

## Usage
⚠️ From this point on, go completely root ⚠️ 

```shell
./Yggdrasil.sh help
```

```
Help :

Usage: Yggdrasil.sh <command> [argument]

Available Commands :
  build    		build service
  start    		Start service
  stop     		Stop service
  stoprm		Stop and remove containers
  status   		Display status
  list     		List tools
  exec     		Execute a command
  manexec  		Execute a command manually
  enter    		Enter in a service in interactive mode
  record   		Start the recording of the terminal
  extract  		Extract data from a service
  remove   		Delete a service
  remove-image   	Delete images
  help     		Display the Help Menu

Use case :

Build service :
  Yggdrasil.sh build <service>

Start service :
  Yggdrasil.sh start <service>

Stop service :
  Yggdrasil.sh stop <service>

Stop and remove containers :
  Yggdrasil.sh stoprm <service> 

Display status :
  Yggdrasil.sh status <service>

List service-related tools :
  Yggdrasil.sh list <service>

Execute a command :
  Yggdrasil.sh exec command

Execute a special command specifying the service container (useful for applications not specified in the tool_mapping file) :
  Yggdrasil.sh manexec <service> command

Enter a service in interactive mode :
  Yggdrasil.sh enter <service>

Execute a command in a service manually :
  Yggdrasil.sh manexec <service> command

Start the recording of the terminal to stop it just make CTRL+D or type Exit:
  Yggdrasil.sh record

Extract data from a service :
  Yggdrasil.sh extract <service>

Delete a container of service :
  Yggdrasil.sh remove <service>

Delete image :
  Yggdrasil.sh remove-image <service>

```

[![asciicast](https://asciinema.org/a/590862.svg)](https://asciinema.org/a/590862)

### Some Issues
Several tests have been done on different "OS", ubuntu and Arch among others, everything is functional, however some errors may be present depending on my code or not.

##### Issue 1
Docker installation failed?
If so you can install it with your package manager

##### Issue 2
The installation of docker-compose failed?
If so you can install them with your package manager, but normally the script part should be working, you can however check the available version and update the variable in the docker-install.sh script.
to check the latest version: https://github.com/docker/compose/releases/  
the installation script will be updated in a future release, allowing the user to choose the version he needs  

##### Issue 3
The verification of the digest of gvisor, can be a problem for you and thus not to set up the runtime runsc, you can bypass that by commenting the part of verification in the script gvisor-install.sh, however I do not advise it to you, that warns you either of the fact that the package is up to date but the sum file was not updated, or worse that the binary is not at all integrated and that this last one was altered.

It is possible to install gvisor in another way than the script provided, especially with your package manager, I provide you the documentation of gvisor on the installation:
https://gvisor.dev/docs/user_guide/install/  
