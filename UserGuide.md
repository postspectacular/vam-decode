# V&A Decode User Guide #

## Identity concept ##

The conceptual starting point for the identity was the observation that code, just like our human languages, consists of many different layers of abstraction. Using abstraction any concept can be decomposed into increasingly smaller & fundamental components and processes. Just as we can describe any concept with our human language on these various levels of abstraction, so we can with code too. We can talk DNA, nucleii, cells, organs, bodies, animals, biology or just living things - each of these terms also fully includes and encloses all the previously mentioned terms, thus forming a nested structure similar to onion skins. Thinking about the actual meaning of each of these terms, we can also deduce that the more general the term, the further out the semantic layer, the less precise and so the lower is its level of detail.

### An excursion into mapping ###

Using this mental image of onion skins and applying it to a wordmark in a graphic design context, we need to create a suitable structure visualizing these nested layers. Terrain maps (especially hiking maps) often show contour lines to visualize the different elevations present in the mapped area. The lines are drawn along threshold elevations and indicate the area within this contour outline is at least as high as the indicated elevation. Often this is coupled with colour coding to make this visualization more obvious. The more contour lines are present in a map, the more precise an image we get of the overall structure of the mapped terrain. The same concept can also be applied to three dimensional spaces. However, in a true 3D context elevation is not the most suitable metaphor for defining contours. Instead we imagine each point in that 3D space to have a different density and then can choose contours to wrap around areas of a given density value. The equivalent of a contour line in 3D space is a contour surface enclosing a volume. As an example, this technique is most commonly used for visualizing medical MRI scan data: bones have a higher density than tissue and by choosing the correct threshold we can "carve out" the volume only representing the points of the scanned body part occupied by bones. We will do the same for creating contours of the Decode identity wordmark.

### From text to contours ###

Starting with the word "decode", a single word, we have to transform this piece of text several times in order to create a true 3D representation of it. The transformation steps are briefly shown in the figure below and are described in further detail in the [development guide](DevGuide.md).

[![](http://farm3.static.flickr.com/2684/4122067290_52134b0d1f.jpg)](http://www.flickr.com/photos/toxi/4122067290/)

The following table shows the basic concept of the transformation using 2D slices of the actual 3D volumetric version used in the identity...

| [![](http://farm3.static.flickr.com/2793/4134748528_1bdc5bbe8e_m.jpg)](http://www.flickr.com/photos/toxi/4134748528/) | [![](http://farm3.static.flickr.com/2599/4134748468_c255f162a5_m.jpg)](http://www.flickr.com/photos/toxi/4134748468/) | [![](http://farm3.static.flickr.com/2703/4133985781_b5cca551c1_m.jpg)](http://www.flickr.com/photos/toxi/4133985781/) |
|:----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|
| 2D bitmap of the word in V&A type face | 2D slice of the volumetric space | slice with 4 contours |

Separating out the 4 different contours of that last image then results in these shapes:

| [![](http://farm3.static.flickr.com/2582/4133985749_76bff4d80c_m.jpg)](http://www.flickr.com/photos/toxi/4133985749/) | [![](http://farm3.static.flickr.com/2521/4134748322_01587297f3_m.jpg)](http://www.flickr.com/photos/toxi/4134748322/) | [![](http://farm3.static.flickr.com/2502/4133985657_e5f8b474c7_m.jpg)](http://www.flickr.com/photos/toxi/4133985657/) | [![](http://farm3.static.flickr.com/2647/4133985611_dc3e6930f7_m.jpg)](http://www.flickr.com/photos/toxi/4133985611/) |
|:----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------|
| Contour outline at 25% | Contour outline at 50% | Contour outline at 75% | Contour outline at 100% |

This wireframe image also shows these 4 nested 3D contour surface meshes, partly curled up to reveal inner structures...

[![](http://farm3.static.flickr.com/2609/4101014430_56c5b69e7d.jpg)](http://www.flickr.com/photos/toxi/4101014430/)

## Getting started... ##

The identity application is fully interactive and can be controlled via mouse, keyboard and various graphical user interface controls described below. The application lets you manipulate most parameters in realtime to create a variety of different looks and we encourage you to take the time to experiment to create your own version and submit it as part of the "Recode" competition.

## General features ##

The identity generator application has the following features:

  * Dynamic rendering of a chosen word in the style of the Decode identity
  * Detailed customization features for colours, textures, structure, graphical composition and level of detail
  * Exporting of high resolution stills & video assets as image sequences
  * Customizable via graphical user interface & [configuration file](UserGuideConfig.md)

## The user interface ##

Below follows a description of the graphical user interface. **Please also see this separate page [about mouse & keyboard shortcuts](UserGuideKeyboard.md).**

### Present ###

This first tab of the user interface is empty and so purely serves for presentation purposes to avoid cluttering the visual with interface elements.

### Main ###

[![](http://farm3.static.flickr.com/2568/4121291665_93dac3b5de.jpg)](http://www.flickr.com/photos/toxi/4121291665/)

#### Text input ####

Using this text field you can type in your own (short) word to be used instead of the default "decode". Press `Enter` to confirm.

#### Background colour ####

The background colour can be changed using the red, green blue component sliders. The change happens smoothly over a couple of seconds.

#### Background gradient ####

Using this slider the intensity of the background gradient can be adjusted. Alternatively, use the "gradient" button to turn the gradient on/off.

#### Manual cursor ####

As discussed above, by default each mesh layer has its own autonomous focal point controlling the epi centre of its explosion. By dragging the mouse with the **right** mouse button you can manually override this behaviour and have all layers reacting to the same point. For ease of use this point will remain active even after the mouse button has been released again, but can be disabled again using this interface button.

#### Cursor damping ####

The above mentioned manual focus point is attached to the mouse via a spring, thus creating a somewhat bouncy behaviour. Using this slider you can adjust the springiness.

#### Freezing animation ####

The animation of the meshes can be frozen at any given moment, either using this button or pressing `u` on the keyboard. Even if the animation is stopped, you can still adjust any view settings (or change the texture/colour of each mesh).

The following parameters are only available if your graphics card supports the full feature set of the application (i.e. has support for pixel shaders). The purpose & behaviour of the shaders used is described in detail in the [development guide](DevGuideShader.md).

#### Fresnel power ####

This slider controls the overall impact of the chromatic aberration effect of the applied textures.

#### RGB refraction ####

To create the illusion of chromatic aberration, each colour channel will need to have slightly different refraction settings. You can control them in realtime using these 3 sliders.

#### Lights ####

By default lighting is enabled. However in some circumstances you can achieve a better contrast/effect by turning it off (also by pressing 'L' on the keyboard). Turning off lighting will blow out bright colours and generally oversaturate them...

#### Updating normals ####

As explained on the [shader page](DevGuideShader.md) of the wiki, the texturing of triangles is achieved through environment cube mapping. By default each frame the orientation vector of each triangle is updated and as the triangles move, different parts of the texture will be mapped on to them. Turning off the updating of these normal vectors will create a slightly "oily" (shiny) look & feel as compared to the more crystalline default look.

### Camera ###

[![](http://farm3.static.flickr.com/2539/4121291911_bd5ae04265.jpg)](http://www.flickr.com/photos/toxi/4121291911/)

**The camera view can be rotated by holding down Shift + dragging the mouse**. However, the camera system has various other parameters you can control interactively:

#### Zoom ####

This slider allows you adjust the camera distance.

#### Position ####

The camera is positioned in 3D space. You can reposition it using these 3 sliders.

#### Transition speed ####

Changes to the zoom and position parameters are not immediate, but are applied gradually. Using the zoom speed and translation speed sliders combined with the camera preset feature described below, you can easily create smooth transitions from one view angle to another.

#### Auto rotation ####

Auto-rotation is a modulation of the current view orientation. If enabled the view slightly (and slowly) rotates -/+15 degrees around the current X rotation and -/+30 degrees around Y. This creates a somewhat hovering, weightless feel.

#### Reset arc ball ####

Use this button to quickly reset the view into its default state (front on).

#### Camera presets ####

Camera settings can be stored as presets and then quickly recalled via the GUI or by pressing keys `1 - 9` (by default only 5 presets are defined though). Up to 9 preset slots are available. With each preset the following settings are stored:

  * arc ball orientation
  * camera position
  * zoom
  * background color
  * background gradient intensity

When triggering a preset, the switch will not be immediate, but happen gradually based on the [transition speed sliders](#Transition_speed.md) mentioned above.

### Layers ###

[![](http://farm3.static.flickr.com/2638/4121292061_712a4efcb4.jpg)](http://www.flickr.com/photos/toxi/4121292061/)

This interface tab allows you to control parameters of individual mesh layers. Please visit the [recode guide](DevGuide#General_overview_of_components.md) for a diagram showing how these parameters below influence & relate to the overal identity setup.

#### Layer toggle ####

On/off switch for each given layer/mesh.

#### Contour value ####

Contour threshold value. The lower the value, the more blobby, undefined the mesh shape. The higher the threshold the closer the contour will be to the spine of the letters ([see above](#From_text_to_contours.md). Though, due to the low resolution of the volumetric space, don't expect decent legibility. This was somewhat intentional, but also partly caused by other technical constraints...

#### XY Focus point speed ####

Each layer's explosion epicentre/focus point is continuously moving in the XY plane. The points X and Y coordinates are modulated individually using (by default) out-of-sync sinewaves and thus creating [Lissajous curves](http://en.wikipedia.org/wiki/Lissajous_curve).

#### Explode amount ####

Adjust the maximum intensity of the explosion for this layer. By default this amplitude was set to be inverse proportional to the contour threshold, the lower the threshold the stronger the explosion. However, you can achieve different effects by e.g. setting all layers to the same level etc.

#### Explode frequency ####

Just as the explosion focus point position is modulated using sine waves, so is the explosion intensity. This slider adjusts the frequency/speed of the explosion changes... In combination with the previous parameters this one is one of the most impactful on the overall pace of the identity.

#### Texture / colour ####

If your graphics card supports shader, a different texture can be assigned to each mesh layer. The application comes with 5 default textures but these can be replaced with your own versions. [See here](UserGuideConfig#Textures.md) for more information about that...

If shaders are not supported, the meshes are rendered using plain colours only as fallback solution. Again by default there're 5 predefined colours to choose from for each layer, but you can randomize them to create new variations...

#### Randomize colours ####

This button will only be available if shaders are **not** supported. Pressing this button picks a new random pool of 5 colours which can be applied to the meshes via the radio buttons described above.

### Mesh ###

[![](http://farm3.static.flickr.com/2788/4122065046_61f93ac30a.jpg)](http://www.flickr.com/photos/toxi/4122065046/)

This part of the interface allows you to customize the way meshes are build by allowing you to control the duration of the build process as well as direction.

#### Mesh build speed ####

This slider defines the number of triangles to be added each frame whilst rebuilding the meshes. A low number will prolong this rebuild process for several seconds, whereas a high number might cause the meshes to fully appear immediately.

#### Mesh build mode ####

The rebuilding of meshes can happen in different ways/directions:

  * grow from the left
  * grow from the centre (world space origin)
  * grow from the current position of the manual explode cursor

#### Rebuild meshes ####

Triggers the rebuilding of meshes. If the animation was frozen, it will be automatically started again.

### Export ###

[![](http://farm3.static.flickr.com/2754/4121292269_aab038468d.jpg)](http://www.flickr.com/photos/toxi/4121292269/)

**For instructions how to export assets for submission to the Recode competition, please read over here: [Export instructions](DevGuideExport.md)**

#### Number of tiles ####

Use this slider to adjust the output size of exported high res images.

#### Export high res image ####

Press this button (or 'T' on the keyboard) to export the current frame as high resolution bitmap. The rendering happens by rendering small parts (tiles) of the image in quick succession. These tiles are automatically sliced back together into a single large image behind the scenes. See the [export instructions](DevGuideExport.md) for more detail.

#### Export image sequence ####

Exporting can be started & stopped at any moment by pressing `SPACE` or using the corresponding GUI button in the "export" tab of the interface. During recording you can still fully interact with the piece and all your actions will
become part of the recording...
