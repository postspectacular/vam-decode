# Recode: Export instructions #

## Exporting image sequences ##

Anything done when using the application can be captured as image sequence (without the GUI) and then later combined into a proper video file, e.g. using Adobe After Effects or Apple Quicktime player.

Exporting can be started & stopped at any moment by pressing `SPACE` or using the corresponding GUI button in the "export" tab of the interface.

If you want to record assets for submission to the "Recode" competition and for it to be shown on CBS screens throughout London Underground, please ensure you're using the correct settings:

  * resolution 1280 x 720 pixels (HD720)
  * framerate of the final video file should be 25fps
  * duration 20 seconds
  * the last 2 seconds of the animation need to be a freeze frame (or VERY slow movement only)

## Exporting high-res bitmaps ##

With the current configuration of the application you can (theoretically) export images up to 2167 x 1219 mm @ 300 dpi resolution (25600 x 14400 pixels!), which should be more than sufficient for most purposes. However, images that large require lots of memory and you will have to adjust your application settings to actually export at this size.

By default, the application will only reserve up to 640MB of RAM. This is "only" sufficient for exporting images up to roughly 1300 x 731 mm (15360 x 8640 pixels). This size equals a setting of **12 tiles** on the corresponding GUI slider.

If you really want/need to increase the memory requirements for the application do the following:

### Mac OS X ###

  1. Right click on the DecodeIdent.app file in the finder and choose "Show package contents".
  1. Open the `Info.plist` file in the `Contents` folder
  1. Edit the **VMOptions** item to read e.g. `-Xmx1024m` (to reserve 1024MB = 1GB)
  1. Save the `Info.plist` file
  1. Restart the application

[![](http://farm3.static.flickr.com/2711/4134370089_72973e4228.jpg)](http://www.flickr.com/photos/toxi/4134370089/)

### Windows ###

  1. Edit the `run.bat` file with a text editor of your choice
  1. Change the number in the `-Xmx` parameter to something higher, see above.
  1. Save & restart app

```
java -Xms160m -Xmx640m ...
```

## Exporting code changes ##

### Building an application ###

Processing allows you to easily export your code changes as an applet for viewing inside a web browser or as standalone application. In the Processing environment you'll find an export button in the toolbar above the text editor to that. You can choose one or more target platforms for which to build an application (OSX, Windows or Linux).

[![](http://farm3.static.flickr.com/2697/4137657133_4a0846bc19_o.png)](http://www.flickr.com/photos/toxi/4137657133/)

Once the application has been built, you'll also need to copy the `config` folder inside the created application folders. E.g. copy `config` into `application.macosx`. This folder isn't copied automatically because Processing doesn't know about its presence and so needs to be done manually.

For existing Processing users wondering why we didn't put the config file into the `data` folder: The short answer is that keeping it outside/separate allows us to still edit the config file for the compiled standalone application. The contents of the `data` folder on the other hand are being stuffed inside the main application JAR file and so become hidden & uneditable...

[![](http://farm3.static.flickr.com/2676/4137665313_8a01bc10ff.jpg)](http://www.flickr.com/photos/toxi/4137665313/)

### Windows applications ###

The default Processing application launcher for Windows is not 100% reliable and so you might want to use a batch file to launch the application instead. To do so you can copy & paste the code below into a new textfile called `run.bat` which you'll have to save in the generated `application.windows` folder:

```
java -Xms150m -Xmx640m -cp lib\DecodeIdent.jar;lib\colorutils.jar;lib\controlP5.jar;lib\core.jar;lib\glgraphics.jar;lib\gluegen-rt.jar;lib\jogl.jar;lib\opengl.jar;lib\toxiclibscore.jar;lib\volumeutils.jar -Djava.library.path=lib DecodeIdent
```

If you have changed the name of your sketch from `DecodeIdent` you'll also have to edit the 2 occurance in this batch file:

  * change the name of the JAR file from `DecodeIdent.jar`
  * change the last name of the above code from `DecodeIdent`

If your new version is making use of additional libraries not used by the original version, you'll also have to list them as part of the `-cp` (classpath) parameter. The library JARs should have been automatically placed into the `lib` folder when exporting the application.

### License information ###

Please remember that the original application is licensed under the GNU General Public License v3 and if you're submitting "recoded" works based on actual code changes you're obliged to also provide us with the source code of your modified version.

All truly recoded works will also be published here as part of this project on Google Code.