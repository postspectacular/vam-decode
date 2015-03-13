# Customizing the app via the configuration file #

Below is a short description of the various parameters defined in the application's config file, located in `config/app.properties`. This is a normal, plain text file and can be edited with any text editor.

Each line defines a different parameter. Lines starting with `#` are comments and are not used by the software.

## Application settings ##

The following parameters define the window size, background colour and where to load the usage instructions from which are displayed in the first tab of the user interface.

```
########################################################################
#
# Main configuration file for the DecodeIdent application
#
# Please edit this file only if you know what you're doing!
# Consult the project wiki for further information:
#
# http://decode.googlecode.com
#
# We recommend backing up this original file before making any changes.
#
########################################################################

app.width=1280
app.height=720
app.bgcolor=00cadc

app.usage.file=config/usage.txt
app.usage.enabled=true
```

## Word mark & font settings ##

These parameters define the default wordmark and the typeface used for rendering it.

```
########################################################################
#
# Seed message/wordmark & font settings 
#
########################################################################

volume.seed.message=decode
volume.seed.font=VATheSansPlain-48.vlw
volume.seed.font.size=48
volume.seed.font.baseline=48
```

## Volumetric space ##

Here you can adjust the overall size and resolution of the volumetric space. By increasing the resolution settings, be aware that this will also cause a drastic increase in the number of triangles used for each mesh and so might negatively impact the overall performance of the piece. It is also recommended to keep the overall ratios similar to the original settings to avoid further code changes. E.g. the default resolution of the space is 40x32x32 cells, so you could change it into 80x64x64 cells (for double resolution)

```
########################################################################
#
# Volumetric space settings
#
########################################################################

volume.resolution.x=40
volume.resolution.y=32
volume.resolution.Z=32

volume.scale.x=576
volume.scale.y=256
volume.scale.z=512

volume.brush.size=0.052
```

## Contour layers ##

Using these parameters you can adjust the number of contours used and/or define the following for each layer:

  * contour threshold (called "iso" setting)
  * explosion amplitude
  * discplacement amount (only used for layer0)
  * explosion focus speed
  * texture ID or colour ID (also see further below)

```
########################################################################
#
# Contour layer & mesh configuration
#
########################################################################

volume.layer.count=4

volume.layer0.iso=0.05
volume.layer1.iso=0.8
volume.layer2.iso=2
volume.layer3.iso=4

volume.layer0.explode.amp=30
volume.layer1.explode.amp=20
volume.layer2.explode.amp=10
volume.layer3.explode.amp=3

volume.layer0.displace.width=200
volume.layer0.focus.x=0
volume.layer0.focus.speed=0
volume.layer0.focus.min=-1000
volume.layer0.focus.max=1000

volume.layer0.texture=0
volume.layer1.texture=1
volume.layer2.texture=2
volume.layer3.texture=2

volume.layer0.color=3
volume.layer1.color=2
volume.layer2.color=1
volume.layer3.color=0
```

## Texture, colour & shader ##

By default 5 different textures & colours are defined. Only the default colours can be directly adjusted via the config file. Adding or replacing textures is only possible using the source version of the application and there you need to place them in the `data/tex` folder.

If you want to use your own GLSL shaders, this is also only possible using the source distribution. Shaders need to be placed in the `data/glsl` folder and then referenced from here...

```
########################################################################
#
# Colour, texture & GLSL shader settings
#
########################################################################

texture.count=5

mesh.color.count=5
mesh.color0=ffffff
mesh.color1=ff0000
mesh.color2=ff6600
mesh.color3=2200cc
mesh.color4=00ccff

shader.name=glsl/phong_chromatic
shader.param.fresnel=5
shader.param.etaR=0.65
shader.param.etaG=0.67
shader.param.etaB=0.66
```

## Camera presets ##

This last section of the config file defines 5 camera presets, each consisting of the following parameters:

  * arcball orientation as quaternion (w,x,y,z order)
  * camera position
  * camera zoom

```
########################################################################
#
# Camera preset settings
#
########################################################################

cam.preset.count=5

cam.preset0.quat=1,0,0,0
cam.preset0.pos=0,0,0
cam.preset0.zoom=1

cam.preset1.quat=0.880743,-0.4486474,-0.05444163,0.14157408
cam.preset1.pos=0,0,0
cam.preset1.zoom=1.3

cam.preset2.quat=0.893077,0.019295083,-0.43387043,0.11747345
cam.preset2.pos=0,0,0
cam.preset2.zoom=1.3

cam.preset3.quat=0.834618,-0.014309192,0.5505956,0.007253087
cam.preset3.pos=160,0,0
cam.preset3.zoom=2.35

cam.preset4.quat=0.9054235,0.3273945,0.16621783,0.21305555
cam.preset4.pos=0,0,0
cam.preset4.zoom=1
```