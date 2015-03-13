# GLSL Vertex & Pixel shaders #

The application is using OpenGL shaders to create the glimmering, fractured & textured look of the rendered meshes. Shader functionality should be present on most graphics cards since 2005, however if you're having an older card or onboard graphics chip (e.g. Intel 950) in your machine, you might be out of luck and the app will automatically operate in a fallback mode using only flat colours for rendering the meshes. In this case you can skip this section of the guide...

## Environment cubemapping & chromatic aberration ##

The shaders used for achieving the identity look are based on examples from the OpenGL Orange book by Randy Rost. Combined, the shaders handle the following 3 techniques and are executed for each triangle vertex (first) and then each rendered pixel (second).

### Cube mapping ###

Environment mapping is a common technique to create a sense of shiny, reflective surfaces. Each triangle has a so called _normal vector_ pointing in the direction the triangle is facing. In cube mapping this vector is used to find points in an invisible textured cube surrounding the model. The colour information of this texture is then used for shading/texturing the triangle.

Read here for more information about: [cube mapping](http://en.wikipedia.org/wiki/Cube_map).

### Phong shading ###

Phong shading is one of the traditional means to simulate light effects when rendering 3D geometry. Again using the normal vector of a triangle we can measure its angle toward the light source and use it to calculate the influence this light source has.

Read here for more information about: [phong shading](http://en.wikipedia.org/wiki/Phong_shading).

### Chromatic aberration ###

Chromatic aberration is a property usually associated with cheap lenses and refers to its behaviour of refracting different light colours in a non-uniform manner. In digital photography the effect can be observed as often purple fringing of fine details or edges with sharp contrast. Sending a light beam through a prism also causes chromatic aberration and white light is spread into its different components, causing a rainbow effect upon leaving the prism.

We can simulate this effect by choosing different refraction factors for the red, green & blue colour channels of each pixel, thus also introducing more colours and a rainbow effect of the underlying texture.

Read here for more information about: [chromatic aberration](http://en.wikipedia.org/wiki/Chromatic_aberration).

## Shader language ##

OpenGL shaders are written using the [GLSL](http://en.wikipedia.org/wiki/GLSL) language and are split into vertex shaders, which are executed for each triangle vertex and fragment shaders (also called pixel shaders), executed for each rendered pixel.

Below is the source code for both shaders applying the above mentioned concepts.

### Vertex shader ###

```
/*
 * Vertex shader for chromatic aberration effect.
 *
 * Author: Randi Rost
 *
 * Copyright (c) 2003-2006: 3Dlabs, Inc.
 * See 3Dlabs-License.txt for license information
 *
 * Modified from the original example and combined with phong shading
 * by Karsten Schmidt.
 */

const float F = 0.05;

uniform float etaR;
uniform float etaG;
uniform float etaB;
uniform float fresnelPower;

varying vec3  reflect;
varying vec3  refractR;
varying vec3  refractG;
varying vec3  refractB;
varying float ratio;

varying vec3 normal, lightDir, eyeVec;

void main() {
    vec4 ecPosition  = gl_ModelViewMatrix * gl_Vertex;
    vec3 ecPosition3 = ecPosition.xyz / ecPosition.w;

    vec3 i = normalize(ecPosition3);
    vec3 n = normalize(gl_NormalMatrix * gl_Normal);

    ratio   = F + (1.0 - F) * pow(1.0 - dot(-i, n), fresnelPower);

    refractR = refract(i, n, etaR);
    refractR = vec3(gl_TextureMatrix[0] * vec4(refractR, 1.0));

    refractG = refract(i, n, etaG);
    refractG = vec3(gl_TextureMatrix[0] * vec4(refractG, 1.0));

    refractB = refract(i, n, etaB);
    refractB = vec3(gl_TextureMatrix[0] * vec4(refractB, 1.0));

    reflect  = reflect(i, n);
    reflect  = vec3(gl_TextureMatrix[0] * vec4(reflect, 1.0));

    normal = gl_NormalMatrix * gl_Normal;

    vec3 vVertex = vec3(gl_ModelViewMatrix * gl_Vertex);

    lightDir = vec3(gl_LightSource[0].position.xyz - vVertex);
    eyeVec = -vVertex;
    
    gl_Position = ftransform();
}
```

### Pixel shader ###

```
/*
 * Fragment shader for chromatic aberration effect.
 *
 * Author: Randi Rost
 *
 * Copyright (c) 2003-2006: 3Dlabs, Inc.
 * See 3Dlabs-License.txt for license information
 *
 * Modified from the original example and combined with phong shading
 * by Karsten Schmidt.
 */

const float F = 0.05;

uniform float etaR;
uniform float etaG;
uniform float etaB;
uniform float fresnelPower;

varying vec3  reflect;
varying vec3  refractR;
varying vec3  refractG;
varying vec3  refractB;
varying float ratio;

varying vec3 normal, lightDir, eyeVec;

void main() {
    vec4 ecPosition  = gl_ModelViewMatrix * gl_Vertex;
    vec3 ecPosition3 = ecPosition.xyz / ecPosition.w;

    vec3 i = normalize(ecPosition3);
    vec3 n = normalize(gl_NormalMatrix * gl_Normal);

    ratio   = F + (1.0 - F) * pow(1.0 - dot(-i, n), fresnelPower);

    refractR = refract(i, n, etaR);
    refractR = vec3(gl_TextureMatrix[0] * vec4(refractR, 1.0));

    refractG = refract(i, n, etaG);
    refractG = vec3(gl_TextureMatrix[0] * vec4(refractG, 1.0));

    refractB = refract(i, n, etaB);
    refractB = vec3(gl_TextureMatrix[0] * vec4(refractB, 1.0));

    reflect  = reflect(i, n);
    reflect  = vec3(gl_TextureMatrix[0] * vec4(reflect, 1.0));

    normal = gl_NormalMatrix * gl_Normal;

    vec3 vVertex = vec3(gl_ModelViewMatrix * gl_Vertex);

    lightDir = vec3(gl_LightSource[0].position.xyz - vVertex);
    eyeVec = -vVertex;
    
    gl_Position = ftransform();
}
```