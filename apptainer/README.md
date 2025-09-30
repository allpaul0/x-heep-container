# Apptainer
This folder contains the **definition files (.def)** to build the [X-HEEP](https://github.com/esl-epfl/x-heep) apptainer container. 
It can be built using the provided **Makefile**. 

# Container content

![alt text](<layered_x-heep_container.PNG>)

## This is a development container
The X-HEEP folder shall already be cloned on the host system and ought to be **binded at runtime** to the container. This methodology allows using the X-HEEP folder as a **continuous dev environment** (R/W filesystem, persistence of datal, live editing, ...). 

## To turn this into a production container
A different approach would consist of **not binding the X-HEEP folder at runtime** and inserting it in the layered container build. This means **inserting X-HEEP as a frozen, immutable snapshot** of the project for **archival/release purposes**, with a compiled binary. 
The base layer could then be changed from Ubuntu to Alpine or built from scratch for execution of X-HEEP solely, making it **much lighter**. 
This removes the ability to edit the code in the container interactibely or compile it. 

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
Let's say your build from gcc failed or you used the wrong parameters, you can rebuild that specific layer. 

```bash
make gcc
```
-> **reuses corev.sif** (the previous layer), avoids a **full rebuild**, hence the layered approach. This is usefull if you need to tweak some configs in the upper layers. 

If you need to recurrently modify a layer at the bottom, you can move it up the pile, rebuild all the previous layers, so that it will be built last and spare the build time of the other layers when you iterate on your modification. 

Layered approach **is not faster** than building one container image straight but it allows to **set break points** and **iterate on a layer without rebuilding the entire stack**. 


# Run the container 

There is no need to activate the vitual environment (**core-v-mini-mcu**) after entering the container, it is automatically activated. See `conda.def`, `%environment` section. 

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



