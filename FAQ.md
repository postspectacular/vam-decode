# Frequently Asked Questions & Troubleshooting #

The questions below try to address some of the things you might encounter. If you have any other problems with **USING** the software, please add them via the comments below. If you have specific questions about **RECODING**, please see the [development notes](DevGuide.md) and use the feedback mechanism mentioned there. Thanks a lot!

## App doesn't start ##

Most likely cause is the lack of a suitable Java runtime environment on your machine. Did you read the [requirements & installation instructions](Installation.md)? Another cause might be insufficient RAM available to launch. The app initially tries to reserve at least 128MB of RAM and usage can grow up to 640MB when exporting high resolution assets (by default, can be edited via `run.bat`/`run.sh` files or editing the `info.plist` file for the OSX version)

## App launches but my graphics look different than the official images ##

Most likely your graphics card does not support all the required features and so you're seeing the fallback version using only a single colour for each mesh layer. In order to recreate the original look, your graphics hardware needs to support OpenGL Vertex & Pixel Shaders.

## App doesn't fill the screen ##

The downloadable application is by default set to a 1280x720 screen resolution and to change the size you'll have to edit the [configuration file](UserGuideConfig.md). Then try again with the new settings.

## App is running, but very sluggish (< 5fps) ##

During the exporting of an image sequence, the application will be running much slower than normal since each frame has to be saved to disk. If performance is sluggish when not exporting, then this is most likely caused by insufficient RAM causing your system to repeatedly swap virtual memory from disk: http://en.wikipedia.org/wiki/Paging. Try editing the RAM settings (see above) and close all other applications.

## App freezes when trying to export high res assets ##

Again, this is probably a RAM issue because the app can't reserve enough memory for the high res image. Make sure your machine satisfies the [minimum hardware requirements](Installation#Minimum_hardware_requirements.md) or try closing other applications before restarting the V&ADecode application. In the default configuration (1280x720 and export tiles = 10) the app will require approx. 560MB of RAM when exporting.

## I edited the config file, but app is not working anymore ##

You'd better kept a backup of the original file. If not, simply download the app again.