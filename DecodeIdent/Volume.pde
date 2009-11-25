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

// this method takes the currently chosen word and renders it into
// an offscreen image buffer which is then used to create a volumetric
// version of the word (see below)
PImage createVolumeSeedImage(SeedConfiguration seed) {
  int w=config.getInt("volume.seed.img.width",192);
  int h=config.getInt("volume.seed.img.height",64);
  seedImg=createGraphics(w,h,JAVA2D);
  seedImg.beginDraw();
  seedImg.background(255);
  seedImg.fill(0);
  seedImg.textFont(seed.font,seed.fontSize);
  seedImg.textAlign(CENTER);
  seedImg.text(seed.message,w/2,seed.baseLine);
  seedImg.endDraw();
  seedImg.loadPixels();
  return seedImg;
}

// This method sets up the volumetric space and surface.
// Calls the createVolumeSeedImage() method above and then
// continues parsing the bitmap image pixel by pixel. For all
// non-white pixels a corresponding set of 3D voxels is drawn
// in the volumetric space (using a VolumetricBrush), resulting
// in a space which has high density areas where the letters
// are in the 2D bitmap.
//
// For more information and examples of similar techniques
// please have a look at the volumeutils package of the toxiclibs
// project at: http://toxiclibs.org/

void initVolume(SeedConfiguration seed) {
  PImage seedImg=createVolumeSeedImage(seed);
  int resX=config.getInt("volume.resolution.x",80);
  int resY=config.getInt("volume.resolution.y",60);
  int resZ=config.getInt("volume.resolution.z",60);
  float sX=config.getFloat("volume.scale.x",576);
  float sY=config.getFloat("volume.scale.y",384);
  float sZ=config.getFloat("volume.scale.z",384);
  float brushSize=config.getFloat("volume.brush.size",0.052);
  Vec3D volumeScale=new Vec3D(sX, sY, sZ);
  volume=new VolumetricSpace(volumeScale, resX, resY, resZ);
  surface = new IsoSurface(volume);
  brush = new RoundBrush(volume, 0);
  float imgScaleX = (float)resX / seedImg.width;
  for (int x = 0; x < seedImg.width; x += 2) {
    brush.setSize(sX * brushSize);
    for (int y = 0; y < seedImg.height; y += 2) {
      int c = seedImg.pixels[x + y * seedImg.width] & 0xff;
      if (c < 255) {
        brush.drawAtGridPos(x * imgScaleX, y / 2, 31, 0.5f);
      }
    }
  }
  volume.closeSides();
}

