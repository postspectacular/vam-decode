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

void initMeshes() {
  if (meshes!=null) {
    for(Iterator i=meshes.iterator(); i.hasNext();) {
      ((DecodeMesh)i.next()).cleanup();
    }
  }
  meshes=new ArrayList();
  for(int i=0; i<layers.length; i++) {
    IsoLayerConfig lc=layers[i];
    DecodeMesh dm=new DecodeMesh(surface,lc);
    meshes.add(dm);
  }
}

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

