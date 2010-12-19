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

/**
 * If lighting is enabled this method is being called every frame from
 * the main draw() loop. It is responsible for setting up 
 */
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

