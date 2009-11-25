/*
 * This file is part of the V&A Decode Identity (DecodeIdent).
 * 
 * Copyright 2009 Karsten Schmidt (PostSpectacular Ltd.)
 * 
 * DecodeIdent is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * DecodeIdent is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with DecodeIdent. If not, see <http://www.gnu.org/licenses/>.
 */

// defines order of faces for the 6-sided cube texture used for environment mapping

int[] cubeMapFaceOrder = new int[]{
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_X, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_Y, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_Z, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
};

int[] textureIDs;

// initializes the configured number of texture bitmaps and
// creates cubemap textures of them
void initTextures() {
  int numTextures=config.getInt("texture.count",1);
  textureIDs=new int[numTextures];
  for(int i=0; i<numTextures; i++) {
    textureIDs[i]=loadCubeMap("tex/tex"+i+".jpg");
  }
}

// creates the OpenGL texture structure, loads a single bitmap file and
// applies it to all 6 sides of the cube texture
int loadCubeMap(String fileName){
  int[] texID=new int[1];
  gl.glPixelStorei(GL.GL_UNPACK_ALIGNMENT, 1);
  gl.glGenTextures(1, texID,0);
  gl.glBindTexture(GL.GL_TEXTURE_CUBE_MAP, texID[0]);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
  gl.glTexEnvf(GL.GL_TEXTURE_ENV, GL.GL_TEXTURE_ENV_MODE, GL.GL_MODULATE);
  println("loading texture: "+fileName);
  PImage img=loadImage(fileName);
  for(int i = 0; i < 6; i++){
    gl.glTexImage2D(cubeMapFaceOrder[i], 0, GL.GL_RGBA8, img.width, img.height, 0, GL.GL_BGRA,  GL.GL_UNSIGNED_BYTE, IntBuffer.wrap(img.pixels));
  }
  return texID[0];
}

