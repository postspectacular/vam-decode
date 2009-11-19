void initLights() {
  TColor matSpecular=TColor.newRGB(1,1,1);

  int lightID1=GL.GL_LIGHT0;
  int lightID2=GL.GL_LIGHT1;
  
  Vec3D lightPos1=new Vec3D(0,-1000,6000).normalize();
  Vec3D lightPos2=new Vec3D(-1000,2000,-6000).normalize();

  TColor lightDiffuse=TColor.newRGB(0.9,0.9,0.9);
  TColor lightAmbient=TColor.newRGB(0.1,0.1,0.1);
  TColor lightSpecular=TColor.newRGB(1,1,1);

  gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL.GL_SPECULAR, matSpecular.toRGBAArray(null), 0);
  gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL.GL_DIFFUSE, TColor.newRGB(0,0,0).toRGBAArray(null), 0);
  gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL.GL_AMBIENT, TColor.newRGB(0.3,0.3,0.3).toRGBAArray(null), 0);
  gl.glMaterialf(GL.GL_FRONT_AND_BACK, GL.GL_SHININESS, 10);

  gl.glLightfv(lightID1, GL.GL_POSITION, lightPos1.toArray(), 0);
  gl.glLightfv(lightID1, GL.GL_DIFFUSE, lightDiffuse.toRGBAArray(null), 0);
  gl.glLightfv(lightID1, GL.GL_SPECULAR, lightSpecular.toRGBAArray(null), 0);
  gl.glLightfv(lightID1, GL.GL_AMBIENT, lightAmbient.toRGBAArray(null), 0);
  
  gl.glLightfv(lightID2, GL.GL_POSITION, lightPos2.toArray(), 0);
  gl.glLightfv(lightID2, GL.GL_DIFFUSE, lightDiffuse.toRGBAArray(null), 0);
  gl.glLightfv(lightID2, GL.GL_SPECULAR, lightSpecular.toRGBAArray(null), 0);
  gl.glLightfv(lightID2, GL.GL_AMBIENT, lightAmbient.toRGBAArray(null), 0);

  gl.glEnable(GL.GL_LIGHTING);
  gl.glEnable(lightID1);
  gl.glEnable(lightID2);
}
