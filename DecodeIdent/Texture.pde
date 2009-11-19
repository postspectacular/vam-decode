int[] cubeMapFaceOrder = new int[]{
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_X, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_Y, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
  GL.GL_TEXTURE_CUBE_MAP_POSITIVE_Z, GL.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z
};

int[] textureIDs;

void initTextures() {
  int numTextures=config.getInt("texture.count",1);
  textureIDs=new int[numTextures];
  for(int i=0; i<numTextures; i++) {
    textureIDs[i]=loadCubeMap("tex/tex"+i+".jpg");
    println("tex id: "+textureIDs[i]);
  }
}

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

