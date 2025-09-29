# Apptainer
This folder contains the **definition files (.def)** to build the [X-HEEP](https://github.com/esl-epfl/x-heep) apptainer container. 
It should then be built using the provided **Makefile**. 

# Container content

![alt text](<layered_x-heep_container.PNG>)

The x-heep folder is a cloned on host system and **binded at runtime** to the container. It allows using it as a **continuous dev environment** (R/W filesystem, persistence of 
datal, live editing, ...). 


# Commands to build the container (take some hours)


## Build the container image layer by layer
```bash
make base
make verilator
make verible
make conda
make corev
make gcc
```

## Build the container image straight

```bash
make gcc
```

## Rebuild a layer using the .sif from previous layers
Let's say your build from gcc failed or you used the wrong ISA, you can rebuild that specific layer. 

```bash
make gcc
```
-> **reuses corev.sif**, avoids a **full rebuild**, hence the layered approach. This is usefull if you need to tweak some configs in the upper layers. 

If you need to modify a layer at the bottom, you can move it up the pile so that it will be built last and spare the build time of the other layers. 

Layered approach **is not faster** than building one container image straight but it allows to **set break points**. 


# Run the container 

There is no need to activate the vitual environment (**core-v-mini-mcu**) after entering the container, it is automatically activated. 

## interactively run the container
Once the image is built, you can run it interactively :
```bash
apptainer shell --bind /home/myuse/x-heep:/x-heep container_layers/gcc.sif
```
here the bind puts x-heep to the root of the filesystem

## run the container
```bash
apptainer exec --bind /home/myuse/x-heep:/x-heep container_layers/
```

# Use X-HEEP
Follow the [README](https://github.com/esl-epfl/x-heep) of X-HEEP to build hardware and run applications.



