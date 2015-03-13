# Installation & requirements #

## Requirements ##

The Decode identity application has been developed with the popular, free & open source tool [Processing](http://processing.org), which itself is based on Java. For that reason, you'll need a recent version of Java installed in order to run the Decode application. Java version 5 or newer is required.

### Hardware requirements ###

  * Mac OSX or Windows
  * 1.6GHz CPU
  * Graphics card with OpenGL vertex & pixel shader support
  * minimum 150MB RAM (up to 640MB required when exporting highres assets)

## Installation ##

### Mac OS X ###

#### Checking the correct version of Java ####
OS X comes with different versions of Java pre-installed, however depending on your actual computer model and version of OSX, different default settings are in place and you should first confirm you're using the right ones. Unless you're already running Snow Leopard, you should also ensure you have actually updated to the latest version via the standard Software Update mechanism.

Open `Java Preferences` in the `Applications/Utilities` folder and **check that `JavaSE 5` or `JavaSE 6` is at the top of both lists**. If not correct the order of preference using drag & drop...

[![](http://farm4.static.flickr.com/3171/4022802206_e6489189f3.jpg)](http://www.flickr.com/photos/toxi/4022802206/)

Alternatively, you can check which version is currently installed by opening Terminal and typing

```
java -version
```

The output should look something like this:

```
java version "1.5xxx"
Java(TM) SE Runtime Environment (build 1.5xxxx)
Java HotSpot(TM) 64-Bit Server VM (build xxxxx)
```

#### Installation ####

  1. Download the latest binary distribution from the [downloads page](http://code.google.com/p/decode/downloads/list).
  1. Unzip the archive to a folder of your liking
  1. Double click the file `DecodeIdent` application in the folder created

[![](http://farm3.static.flickr.com/2635/4127347223_8b56b5e380_o.png)](http://www.flickr.com/photos/toxi/4127347223/)

Once running, go on and read the UserGuide to learn how everything works and can be tweaked...

### Windows ###

Windows does not come with Java pre-installed and unless you're confident that you have a recent version of Java installed, head over to [java.sun.com](http://java.sun.com/javase/downloads/index.jsp) and download & install the latest version (Java 6 Update 17 at the time of writing).

**Important: If you're planning to do any development work with this or any other Java project, download the JDK (Java Development Kit) version, else just get the JRE (Java Runtime Environment).**

You can check which version is currently installed like this:

  * Choose Start menu > Run...
  * Type in `cmd` to launch command line
  * Type in `java -version` and press Enter

The output should look something like this:

```
java version "1.6xxx"
Java(TM) SE Runtime Environment (build 1.6xxxx)
...
```

#### Installation ####

  1. Download the latest binary distribution from the [downloads page](http://code.google.com/p/decode/downloads/list).
  1. Unzip the archive
  1. Double click the file `run.bat` in the folder created

Once running, go on and read the UserGuide to learn how everything works and can be tweaked...

## Troubleshooting ##

If you can't get the app to run or encounter other unexpected behaviours, please do consult the [FAQ](FAQ.md) page for further reference...