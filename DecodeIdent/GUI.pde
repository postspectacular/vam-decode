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
 
int MAX_CAM_PRESETS = 9;

ControlP5 ui;
Textfield uiMessage;

Textlabel uiLabelNumTiles;
Textlabel uiLabelTimecode;
Bang uiExportToggle;
Radio uiSavePresetRadio,uiLoadPresetRadio;

GuiLayerConfig[] guiLayers;

String selectedTabName="default";

void initGUI() {
  ui=new ControlP5(this);
  updateUIColors();
  ui.setAutoInitialization(false);
  ui.getTab("default").setLabel("present");

  int uix=20;
  int uiy=40;

  String tabMain="main";
  String tabCam="camera";
  String tabExport="export";
  String tabLayers="layers";
  String tabMesh="mesh";

  ui.addTab(tabMain);
  ui.addTab(tabCam);
  ui.addTab(tabLayers);
  ui.addTab(tabMesh);

  ui.getTab("default").activateEvent(true);
  ui.getTab(tabMain).activateEvent(true);
  ui.getTab(tabCam).activateEvent(true);
  ui.getTab(tabLayers).activateEvent(true);
  ui.getTab(tabMesh).activateEvent(true);

  if (!online) {
    ui.addTab(tabExport);
    ui.getTab(tabExport).activateEvent(true);
  }

  Slider s;
  Toggle t;
  Bang b;
  Radio r;

  // main tab

  uiMessage = ui.addTextfield("setSeedMessage",uix,uiy,100,20);
  uiMessage.setLabel("logo / message");
  uiMessage.setBroadcast(false);
  uiMessage.setValue(seed.message);
  uiMessage.setBroadcast(true);
  uiMessage.setTab(tabMain);

  s=ui.addSlider("setBGRed",0,1.0,bgColor.red(),uix+200,uiy,100,14);
  s.setLabel("red");
  s.setTab(tabMain);
  s=ui.addSlider("setBGGreen",0,1.0,bgColor.green(),uix+200,uiy+20,100,14);
  s.setLabel("green");
  s.setTab(tabMain);
  s=ui.addSlider("setBGBlue",0,1.0,bgColor.blue(),uix+200,uiy+40,100,14);
  s.setLabel("blue");
  s.setTab(tabMain);

  s=ui.addSlider("bgGradientAlpha",0,1.0,bgGradientAlpha,uix+350,uiy,100,14);
  s.setLabel("gradient intensity");
  s.setTab(tabMain);

  t=ui.addToggle("doShowGradient",doShowGradient,uix+350,uiy+20,14,14);
  t.setLabel("gradient on/off");
  t.setTab(tabMain);

  int yoff;
  if (shader.isSupportedVS) {
    s=ui.addSlider("setFresnel",0,10,5.0,uix,uiy+80,100,14);
    s.setLabel("fresnel power");
    s.setTab(tabMain);

    s=ui.addSlider("setRefractRed",0,2.0,0.6,uix+200,uiy+80,100,14);
    s.setLabel("red refraction");
    s.setTab(tabMain);

    s=ui.addSlider("setRefractGreen",0,2.0,0.63,uix+200,uiy+100,100,14);
    s.setLabel("green refraction");
    s.setTab(tabMain);

    s=ui.addSlider("setRefractBlue",0,2.0,0.66,uix+200,uiy+120,100,14);
    s.setLabel("blue refraction");
    s.setTab(tabMain);
    yoff=160;
  } 
  else {
    yoff=80;
  }

  t=ui.addToggle("doUseGlobalCursor",doUseGlobalCursor,uix,uiy+yoff,14,14);
  t.setLabel("use manual cursor");
  t.setTab(tabMain);

  if (shader.isSupportedVS) {
    t=ui.addToggle("doUseLights",doUseLights,uix,uiy+yoff+40,14,14);
    t.setLabel("lighting on/off");
    t.setTab(tabMain);

    t=ui.addToggle("toggleNormals",doUpdateNormals,uix,uiy+yoff+80,14,14);
    t.setLabel("update normals on/off");
    t.setTab(tabMain);
  }

  ///////////// camera tab

  s=ui.addSlider("setCamDistance",0.3,3,1,uix,uiy,100,14);
  s.setLabel("zoom");
  s.setTab(tabCam);

  s=ui.addSlider("setZoomSmooth",0.005,0.5,cam.zoomSmooth,uix+200,uiy,100,14);
  s.setDecimalPrecision(4);
  s.setLabel("zoom speed");
  s.setTab(tabCam);

  s=ui.addSlider("setCamPosX",-500,500,0,uix,uiy+40,100,14);
  s.setLabel("x position");
  s.setTab(tabCam);

  s=ui.addSlider("setCamPosY",-500,500,0,uix,uiy+60,100,14);
  s.setLabel("y position");
  s.setTab(tabCam);

  s=ui.addSlider("setCamPosZ",-500,500,0,uix,uiy+80,100,14);
  s.setLabel("z position");
  s.setTab(tabCam);

  s=ui.addSlider("setCamPosSpeed",0.005,0.5,cam.panSmooth,uix+200,uiy+40,100,14);
  s.setDecimalPrecision(4);
  s.setLabel("translation speed");
  s.setTab(tabCam);

  t=ui.addToggle("toggleCamAutoRotation",cam.isCamModEnabled,uix,uiy+120,14,14);
  t.setLabel("auto rotation on/off");
  t.setTab(tabCam);

  s=ui.addSlider("setArcballSpeed",0.01,0.5,arcBall.speed,uix+200,uiy+120,100,14);
  s.setDecimalPrecision(4);
  s.setLabel("arcball speed");
  s.setTab(tabCam);

  b=ui.addBang("resetArcBall",uix+400,uiy+120,14,14);
  b.setLabel("reset arcball");
  b.setTab(tabCam);
  
  r =ui.addRadio("setCameraPreset",uix,uiy+160);
  r.setBroadcast(false);
  for(int i=0; i<cameraPresets.size(); i++) {
    r.addItem("load preset #"+(i+1),i);
  }
  r.setTab(tabCam);
  r.setBroadcast(true);
  uiLoadPresetRadio=r;

  r=ui.addRadio("saveCameraPreset",uix+200,uiy+160);
  r.setBroadcast(false);
  for(int i=0; i<cameraPresets.size(); i++) {
    r.addItem("save as preset #"+(i+1),i);
  }
  r.addItem("add as preset",-1);
  r.setTab(tabCam);
  r.setBroadcast(true);
  uiSavePresetRadio=r;

  ///////////// layers tab

  guiLayers=new GuiLayerConfig[layers.length];
  int y=uiy;
  for(int i=0; i<layers.length; i++) {
    GuiLayerConfig l=new GuiLayerConfig(layers[i],ui,tabLayers,i,uix,y);
    guiLayers[i]=l;
    y += (textureIDs.length+1)*14;
  }

  if (!shader.isSupportedVS) {
    b=ui.addBang("randomizeColors",uix,y,28,28);
    b.setLabel("randomize colors");
    b.setTab(tabLayers);
  }

  ///////////// mesh tab

  s=ui.addSlider("meshBuildSpeed",10,200,meshBuildSpeed,uix,uiy,100,14);
  s.setLabel("mesh build speed");
  s.setTab(tabMesh);

  s=ui.addSlider("meshFuzziness",0,1.0,meshFuzziness,uix,uiy+20,100,14);
  s.setLabel("fuzziness");
  s.setTab(tabMesh);

  b=ui.addBang("rebuildMeshes",uix,uiy+60,28,28);
  b.setLabel("rebuild meshes");
  b.setTab(tabMesh);

  r=ui.addRadio("setMeshComparator",uix+200,uiy);
  r.setBroadcast(false);
  r.addItem("grow from centre",0);
  r.addItem("grow from left",1);
  r.addItem("grow from explode focus",2);
  r.setTab(tabMesh);
  r.setBroadcast(true);

  ///////////// export tab

  if (!online) {
    s=ui.addSlider("setNumExportTiles",1,20,numExportTiles,uix+100,uiy,100,14);
    s.setLabel("number of tiles");
    s.setTab(tabExport);

    uiLabelNumTiles = ui.addTextlabel("uiLabelNumTiles", "", uix + 100, uiy + 20);
    uiLabelNumTiles.setTab(tabExport);
    setNumExportTiles(numExportTiles);

    b=ui.addBang("saveTiles",uix,uiy,28,28);
    b.setLabel("export as hi-res");
    b.setTab(tabExport);

    uiExportToggle=ui.addBang("toggleExport",uix,uiy+60,28,28);
    uiExportToggle.setLabel("start recording");
    uiExportToggle.setTab(tabExport);

    uiLabelTimecode=ui.addTextlabel("uiLabelTimecode", "", uix + 100, uiy + 60);
    uiLabelTimecode.setTab(tabExport);
  }
}

void controlEvent(ControlEvent e) {
  if (e.isTab()) {
    selectedTabName = e.tab().getTab().name();
  }
}

void updateUIColors() {
  if (bgColor.brightness()>0.5) {
    ui.setColorActive(0xff333333);
    ui.setColorBackground(0xff666666);
    ui.setColorForeground(0xffcccccc);
    ui.setColorLabel(0xff000000);
    ui.setColorValue(0xff000000);
  } 
  else {
    ui.setColorActive(0xff333333);
    ui.setColorBackground(0xff666666);
    ui.setColorForeground(0xffcccccc);
    ui.setColorLabel(0xffffffff);
    ui.setColorValue(0xffffffff);
  }
}

void setSeedMessage(String txt) {
  seed.setMessage(txt);
  initVolume(seed);
  initMeshes();
  doUpdate=true;
}

void setCamDistance(float zoom) {
  cam.targetZoom=zoom;
}

void setZoomSmooth(float s) {
  cam.zoomSmooth=s;
}

void setNumExportTiles(int num) {
  numExportTiles = num;
  tiler = new Tiler(pgl, numExportTiles);
  int totalWidth = num * width;
  int totalHeight = num * height;
  int px = (int) UnitTranslator.pixelsToMillis(totalWidth, 300);
  int py = (int) UnitTranslator.pixelsToMillis(totalHeight, 300);
  uiLabelNumTiles.setValue(totalWidth + " x " + totalHeight + " (" + px + " x " + py + " mm @ 300 dpi)");
}

void saveTiles() {
  tiler.initTiles(cam.fov, cam.near, cam.far);
  tiler.save(sketchPath("export"), "odz-xl-"
    + (System.currentTimeMillis() / 1000), "tga");
}

void toggleExport() {
  if (exporter.isExporting()) {
    exporter.stop();
    uiExportToggle.setLabel("start recording");
    uiLabelTimecode.setValue("");
  } 
  else {
    if (exporter.newSession()) {
      exporter.start();
      uiExportToggle.setLabel("stop recording");
    } 
    else {
      println("could not create folder for new export session");
    }
  }
}

void toggleCamAutoRotation() {
  cam.toggleModulation();
}

void rebuildMeshes() {
  for(Iterator i=meshes.iterator(); i.hasNext();) {
    DecodeMesh mesh=(DecodeMesh)i.next();
    mesh.restart();
  }
}

void setMeshComparator(int id) {
  switch(id) {
  case 0:
    meshComparator=new FaceDistanceComparator(new Vec3D(),meshFuzziness);
    break;
  case 1:
    meshComparator=new FaceFuzzyXComparator(meshFuzziness);
    break;
  case 2:
    meshComparator=new FaceDistanceComparator(explodeCursor.copy(),meshFuzziness);
    break;
  }
}

void setBGRed(float r) {
  bgColor.setRed(r);
  updateUIColors();
}

void setBGGreen(float g) {
  bgColor.setGreen(g);
  updateUIColors();
}

void setBGBlue(float b) {
  bgColor.setBlue(b);
  updateUIColors();
}

void setRefractRed(float r) {
  shader.begin();
  shader.setParameter("etaR",r);
  shader.end();
}

void setRefractGreen(float g) {
  shader.begin();
  shader.setParameter("etaG",g);
  shader.end();
}

void setRefractBlue(float b) {
  shader.begin();
  shader.setParameter("etaB",b);
  shader.end();
}

void setFresnel(float p) {
  shader.begin();
  shader.setParameter("fresnelPower",p);
  shader.end();
}

void setCamPosX(float x) {
  cam.targetPos.x=x;
}

void setCamPosY(float y) {
  cam.targetPos.y=y;
}

void setCamPosZ(float z) {
  cam.targetPos.z=z;
}

void setCamPosSpeed(float s) {
  cam.panSmooth=s;
}

void randomizeColors() {
  for(int i=0; i<meshColors.length; i++) {
    meshColors[i]=TColor.newRandom();
  }
}

void toggleNormals() {
  doUpdateNormals=!doUpdateNormals;
  if (!doUpdateNormals) {
    for(Iterator i=meshes.iterator(); i.hasNext();) {
      DecodeMesh mesh=(DecodeMesh)i.next();
      mesh.resetNormals();
    }
  }
}

void setCameraPreset(int id) {
  cam.isCamModEnabled=false;
  ((CameraPreset)cameraPresets.get(id)).activate();
}

void saveCameraPreset(int id) {
  if(id==-1) {
    uiSavePresetRadio.removeItem("add as preset");
    if (cameraPresets.size()<MAX_CAM_PRESETS) {
      id=cameraPresets.size();
      uiSavePresetRadio.addItem("save as preset #"+(id+1),id);
      uiLoadPresetRadio.addItem("load as preset #"+(id+1),id);
      uiSavePresetRadio.addItem("add as preset",-1);
      cameraPresets.add(new CameraPreset(arcBall.currOrientation.copy(), cam.pos.copy(), cam.zoom));
    }
  } 
  else {
    CameraPreset cp=(CameraPreset)cameraPresets.get(id);
    cp.set(arcBall.currOrientation, cam.pos, cam.zoom);
  }
}

void setArcballSpeed(float s) {
  arcBall.speed=s;
}

void resetArcBall() {
  arcBall.reset();
}