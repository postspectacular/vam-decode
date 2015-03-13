# The Decode identity Processing sketch #

The identity application source code is split over 16 different files handling various aspects of the application. Each file either consists of a single re-usable class or groups functions which are thematically related for better clarity and making it easier to navigate the source.

The purpose of each file is briefly described below. You can find further comments in the actual source code as well.

## DecodeIdent ##

This file is the main application. It handles the initialization of all assets and other code components as well as the rendering of the entire scene.

## ArcBall ##

An arc ball is a generic, re-usable 3D view orientation controller. The main application needs to forward mouse events to this class and call the `apply()` method from the main `draw()` loop every frame to update the application's 3D view transformation matrix.

## Camera ##

This class encapsulates various camera parameters and provides means for them to change slowly (using interpolation). Settings include:

  * field of view
  * XY rotation
  * position offset
  * zoom
  * clipping planes

You can also turn on optional, automatic rotation modulation using sine waves applied as offset to the current X & Y rotation angles, creating a slowly animating, hovering, weightless feel of the view.

## Config ##

This file contains various configuration classes:

  * The `SeedConfig` message (e.g. the word "decode") used to create the meshes.
  * The `IsoLayerConfig` used to define parameters for each contour layer and its related mesh. The actual parameters for each layer are loaded from the external config file and are described in detail on the [configuration file page](UserGuideConfig.md).

The configuration file is discussed in detail on [this page](UserGuideConfig.md)

## Events ##

This file contains all mouse & keyboard event handlers and forwards them to various application components.

A list of keyboard shortcuts is [over here](UserGuideKeyboard.md).

## FrameExporter ##

A generic, re-usable class for exporting image sequences. Exports are session based and the class creates & places all frames of a recording session in its own timestamped subfolder. This class is used when exporting video assets. The resulting image sequences can be opened with QuickTime player to compile into an actual video file.

## GLSL ##

If a compatible graphics card is present, the application is making use of [GLSL](http://en.wikipedia.org/wiki/GLSL) vertex & pixel shaders to create the fractured, textured look & feel of the created meshes. This class is a simple re-usable component and handles the initialization & management of a hardware shader and its parameters. The actual shader source code is located in the `data/glsl` folder.

For more information about the shaders used, [read over here](DevGuideShader.md).

## GUI ##

The application's GUI is realised using Andreas Schlegel's [ControlP5](http://sojamo.de) library. This file contains the method to create the various interface elements and all controller listeners to react to user changes done via the GUI.

## GUILayerConfig ##

The GUI also gives the user access to various parameters for each individual contour layer/mesh of the overall structure. Because the number of these layers is dynamic and initialized from the config file, this class defines GUI elements individual to each layer. The class is being used by the `initGUI()` method in the [GUI](#GUI.md) file.

## Lights ##

This method initializes various parameters for the OpenGL lighting setup of the scene, e.g. the light position, colour etc.

## Mesh ##

This file is one of the core parts of the application and handles the actual creation, management and distortion of the inidividual meshes created from the seed text/wordmark.

There are 3 interlinked classes to achieve the current look & feel of the identity:

### DecodeMesh ###

This class encapsulates an entire mesh of an individual contour layer. It initializes & updates the underlying OpenGL [Vertex Buffer Object](http://en.wikipedia.org/wiki/Vertex_Buffer_Object) (also see [VBO file](#VBO.md)) and updates all faces based on current user settings/interactions. It also handles the rendering of the mesh.

### DecodeVertex ###

A `DecodeVertex` is a 3D point in space with an attached distortion/extrusion function. The distortion is only used by the outermost contour layer to create the animated spikes moving through the mesh.

### DecodeFace ###

A `DecodeFace` is a collection of 3 `DecodeVertices` forming a triangle. The position of the triangle is changing every frame based on its current distance to the mesh's explosion focal point. The closer a `DecodeFace` is to the focal point the more extreme its displacement. The displacement function is a simple inverse square law equation creating a spherical displacement around the focal point.

## Texture ##

This method handles the loading and initialization of [cube map](http://en.wikipedia.org/wiki/Cube_map) textures required by the [GLSL shader](#GLSL.md) to create the fractured look of the mesh.

## TileExporter ##

A generic, re-usable class for exporting high resolution versions of the currently displayed frame. The size limit of the exported bitmaps is purely down to available RAM. Original code by [Marius Watz](http://workshop.evolutionzone.com), extended by [Karsten Schmidt](http://postspectacular.com).

## Utils ##

When re-building meshes, the faces (triangles) of each mesh are first sorted based on some chosen criteria of the user (e.g. "grow from centre") and are then slowly introduced over time based on their position in the sorted order. This file contains the actual sorting logic of the various criteria using Java's Comparator mechanism.

The file also contains the SpringyPoint class used for the manual explode cursor.

## VBO ##

This file contains a barebones wrapper class for [OpenGL Vertex Buffer Objects](http://en.wikipedia.org/wiki/Vertex_Buffer_Object) used to efficiently draw the contour meshes on screen.

## Volume ##

As described in the [user guide](UserGuide.md), the Decode identity is based on several 3D meshes created from a single piece of text. The text is first transformed into a black & white bitmap image which is then parsed pixel by pixel to create a volumetric space. Using the [toxiclibs volumeutils](http://toxiclibs.org) library several 3D contour meshes are extracted from that volumetric space.

The functions in this file handle all these different transformation steps from plain text into 3D `DecodeMeshes`. Also see a further description in the main [user guide](UserGuide#From_text_to_contours.md) and [over here](DevGuide.md).