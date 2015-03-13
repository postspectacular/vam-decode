# From Decode to Recode: Development notes #

This part of the guide is intented for people not afraid to touch the source code and get their hands dirty. We will attempt to provide as many pointers as possible, but this guide is no tutorial for total programming beginners and of course you'll need to have some prior knowledge when trying to make any changes to the code. Having said that, you're more than welcome to take a peek at the source code regardless. All files and functions are heavily commented to make it easier finding your way around. We also recommend reading [this page](DevGuideProcessingSketch.md) giving a top level description of the various source files of the project...

## Pre-requisites ##

The identity application is open source and so are all the tools the software has been developed with. If you're interested in playing around with the source code version of the identity (don't be afraid to break it, it's software) you'll first need to download the necessary tools & libraries in order for it to run.

### Processing ###

The application has been developed with the popular open source tool/language Processing, developed by [Ben Fry](http://benfry.com) & [Casey Reas](http://reas.com) since 2001. The tool is available for all major platforms (OSX, Windows & Linux) and is piggy-backing on top of Java. It was mainly intended to provide an easy to use & learn environment for artists and designers to get into programming. So for our purposes this is a perfect match...

  * http://processing.org/
  * http://processing.org/download/

[![](http://farm3.static.flickr.com/2629/4134275345_9a99414f97.jpg)](http://www.flickr.com/photos/toxi/4134275345/)

Screenshot of the project opened in Processing.


### Library dependencies ###

In addition to Processing, the identity application is relying on the following (also open source) code libraries:

#### toxiclibs ####

[toxiclibs](http://toxiclibs.org) is Karsten's own collection of code building blocks and provides some of the core functionality for this project. This library collection is modular and you'll need to download the following packages from this page]

  * **toxiclibscore-0015** or newer: the identity app is using the following features of this package:
    * accessing the config file
    * 2D/3D vector math/geometry
    * TriangleMesh container class
    * Wave generators used extensively for various animation tasks
  * **volumeutils-0002** or newer:
    * volumetric space definition
    * volumetric brush tool
    * contour surface extraction using the [Marching Cubes algorithm](http://en.wikipedia.org/wiki/Marching_cubes)
  * **colorutils-0003** or newer:
    * TColor class provides floating point color support, conversion between different color representations and color spaces

#### controlP5 ####

[ControlP5](http://www.sojamo.de/libraries/controlP5/) is an opensource GUI library for Processing developed by Andreas Schlegel. This library is used for realising the user interface of the app. Download instructions are on the library website.

### Installing libraries ###

Processing libraries need to be installed in a specific location on your hard drive. This location is the `libraries` folder inside your Processing sketch folder.

  * On OSX the default path to this folder is: `~/Documents/Processing/libraries`
  * On Windows it is: `My Documents\Processing\libraries`

If you never have run Processing before this folder will not exist and you'll have to create it manually. The correctly installed setup should look like this:

[![](http://farm3.static.flickr.com/2618/4135167951_4589d35eea.jpg)](http://www.flickr.com/photos/toxi/4135167951/)

Image of the folder structure, showing the populated `libraries` folder and the `DecodeIdent` sketch folder copied into the main Processing sketch folder.

## General overview of components ##

[![](http://farm3.static.flickr.com/2649/4122067268_a0d32333a8_o.png)](http://www.flickr.com/photos/toxi/4122067268/)

## Getting started ##

Continue reading the [Processing sketch overview](DevGuideProcessingSketch.md).

## Recode ideas ##

As explained [below](#Volumetric_space.md) the volumetric space is merely a collection of grid cells of different densities. These cells are also called voxels, basically 3D pixels with a value attached to each. This value can be interpreted in many different ways.

The current triangle mesh representation of the volumetric space is just one of an infinite choice of possible visualizations. If you're keen to create an entirely different look, think about interpreting the volumetric representation using different graphics entities.

### Volumetric space ###

Before mentioning some of these alternative possibilities, let's also briefly describe the actual structure of the volumetric space at the heart of the identity.

The volumetric space is a regular cartesian space consisting of a number of cubic cells, also called voxels. Each voxel has a position in space and an attached value, which is usually considered as its "density". This density can of course be interpreted in many different ways. For the original identity we're using it to extract a number of contour surfaces. To achieve this we're utilizing the famous Marching cubes algorithm which results in a triangle mesh of the chosen threshold surface.

// TODO insert image

### Particles ###

Sample all cells of the volumetric space and create a number of particles at the cell's position. The density of each cell is used as a measure for how many particles to create.

### Steering / flocking ###

You could create several moving agents and use the density value of each voxel to limit their range of movement to only areas of a minimum density. Using a sufficient amount of agents (and possibly with different colours) this would create/reveal the overall outline of the wordmark.

### Springs / wireframes ###

Using the existing TriangleMesh approach of the original identity, you could connect all vertices using a physical spring simulation to create a wireframe structure of the wordmark. Have a look at the supplied examples of the [toxiclibs verletphysics](http://toxiclibs.org) library to get started.