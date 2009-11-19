//
// Fragment shader for chromatic aberration effect
//
// Author: Randi Rost
//
// Copyright (c) 2003-2006: 3Dlabs, Inc.
//
// See 3Dlabs-License.txt for license information
//

varying vec3  reflect;
varying vec3  refractR;
varying vec3  refractG;
varying vec3  refractB;
varying float ratio;

uniform samplerCube cubemap;

varying vec3 normal, lightDir, eyeVec;

void main()
{
    vec3 refractColor, reflectColor;

    refractColor.r = vec3(textureCube(cubemap, refractR)).r;
    refractColor.g = vec3(textureCube(cubemap, refractG)).g;
    refractColor.b = vec3(textureCube(cubemap, refractB)).b;

    reflectColor   = vec3(textureCube(cubemap, reflect));

    vec3 color     = mix(refractColor, reflectColor, ratio);

    //vec4 final_color = (gl_FrontLightModelProduct.sceneColor * gl_FrontMaterial.ambient) + (gl_LightSource[1].ambient * gl_FrontMaterial.ambient);
    vec4 final_color = (vec4(1,1,1,1) * gl_FrontMaterial.ambient) + (gl_LightSource[1].ambient * gl_FrontMaterial.ambient);
							
	vec3 N = normalize(normal);
	vec3 L = normalize(lightDir);
	
	float lambertTerm = dot(N,L);
	
	if(lambertTerm > 0.0) {
		final_color += gl_LightSource[1].diffuse * 
		               gl_FrontMaterial.diffuse * 
					   lambertTerm;	
		
		vec3 E = normalize(eyeVec);
		vec3 R = reflect(-L, N);
		float specular = pow( max(dot(R, E), 0.0), 
		                 gl_FrontMaterial.shininess );
		final_color += gl_LightSource[1].specular * 
		               gl_FrontMaterial.specular * 
					   specular;	
	}
	
    gl_FragColor   = vec4(color, 1.0) * final_color;
}