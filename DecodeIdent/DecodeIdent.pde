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
 
import processing.opengl.*;

import java.nio.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import com.sun.opengl.util.*;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.volume.*;
import toxi.util.datatypes.*;
import toxi.math.*;
import toxi.math.waves.*;
import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.geom.util.*;

import controlP5.*;
import codeanticode.glgraphics.*;

TypedProperties config;
SeedConfiguration seed;

int WIDTH=960;
int HEIGHT=540;
public TColor bgColor;
TColor[] meshColors;

PApplet app;
PGraphicsOpenGL pgl;
GL gl;
GLSLShader shader;

PImage bgGradient;
PGraphics seedImg;

VolumetricSpace volume;
IsoSurface surface;
VolumetricBrush brush;
ArrayList meshes;

IsoLayerConfig[] layers;

Tiler tiler;
FrameSequenceExporter exporter;

CameraState cam;
ArrayList cameraPresets;
ArcBall arcBall;

public boolean doUpdate=true;
public boolean doUseLights=true;
public boolean doUseGlobalCursor=false;
public boolean doUpdateNormals=true;
public boolean doShowGradient=true;

public boolean isShiftDown=false;
public boolean isControlDown = false;

public int numExportTiles=3;
public int meshBuildSpeed=33;
public float meshFuzziness=0.1;
public float bgGradientAlpha=1;

public Vec3D explodeCursor=new Vec3D();
public Comparator meshComparator=new FaceDistanceComparator(new Vec3D(),meshFuzziness);

void setup() {
  if (config==null) {
    initConfig();
  }
  size(WIDTH,HEIGHT, OPENGL);
  pgl = (PGraphicsOpenGL) g;
  gl = pgl.gl;
  app=this;
  initSeed();
  initVolume(seed);
  initTextures();
  initColors();
  initLayers();
  initMeshes();
  initCamera();
  initCameraPresets();
  initExporters();
  initShaders();
  initGUI();
  bgGradient=loadImage("tex/circ_grad_1024_2.png");
}

void draw() {
  if (!tiler.isTiling()) {
    cam.update();
    updateLayers();
    updateMeshes();
  }
  cam.setPerspective();
  background(bgColor.toARGB());
  pushMatrix();
  translate(width/2,height/2,0);
  arcBall.apply();
  cam.apply();
  tiler.pre();
  if (doShowGradient) {
    drawBackground();
  }
  pgl.beginGL(); 
  if (doUseLights) {
    if (!shader.isSupportedVS) {
      lights();
      gl.glEnable(GL.GL_LIGHTING);
    } 
    else {
      initLights();
    }
  }
  for(Iterator i=meshes.iterator(); i.hasNext();) {
    DecodeMesh mesh=(DecodeMesh)i.next();
    mesh.render();
  }
  pgl.endGL();
  tiler.post();
  if (exporter.isExporting()) {
    exporter.update();
    uiLabelTimecode.setValue("recording: "+exporter.getTimeCode());
  }
  popMatrix();
  noLights();
  gl.glDisable(GL.GL_LIGHTING);
  imageMode(CORNER);
  hint(DISABLE_DEPTH_TEST);
  showInfo();
}

void drawBackground() {
  hint(DISABLE_DEPTH_TEST);
  imageMode(CENTER);
  tint(255,bgGradientAlpha*255);
  image(bgGradient,0,0,2048,2048);
  noTint();
  hint(ENABLE_DEPTH_TEST);
}

void updateLayers() {
  for(int i=0; i<layers.length; i++) {
    layers[i].update();
  }
}

void updateMeshes() {
  DecodeMesh m=(DecodeMesh)meshes.get(0);
  m.displace();
  if(mousePressed && mouseButton==RIGHT) {
    doUseGlobalCursor=true;
    explodeCursor.interpolateToSelf(new Vec3D(-(width/2-mouseX)*1.5,-(height/2-mouseY)*1.5,0),0.25);
  }
  if(doUpdate) {
    for(Iterator i=meshes.iterator(); i.hasNext();) {
      DecodeMesh mesh=(DecodeMesh)i.next();
      mesh.update();
      mesh.explode(doUseGlobalCursor ? explodeCursor : m.layerConfig.explodeCursor);
    }
  }
}

void showInfo() {
  if (selectedTabName.equalsIgnoreCase("default")) {
    textFont(seed.font);
    textSize(12);
    textAlign(LEFT);
    int numLines=config.getInt("app.info.count",0);
    int leading=16;
    int x=20;
    int y=height-numLines*leading;
    for(int i=0; i<numLines; i++) {
      String l=config.getProperty("app.info"+i,"");
      fill(0,128);
      rect(0,y-leading,textWidth(l)+x+10,leading);
      fill(255);
      text(l,x,y-4);
      y+=leading;
    }
  }
}

void initConfig() {
  InputStream stream;
  config=new TypedProperties();
  println("online: "+online);
  if (online) {
    try {
      stream=new URL(getParameter("decode.config")).openStream();
    }
    catch(Exception e) {
      stream=createInput(sketchPath("config/app.properties"));
    }
  } 
  else {
    stream=createInput(sketchPath("config/app.properties"));
  }
  try {
    config.load(stream);
    if (online) {
      WIDTH=Integer.parseInt(getParameter("width"));
      HEIGHT=Integer.parseInt(getParameter("height"));
      println(WIDTH+"x"+HEIGHT);
    } 
    else {
      WIDTH=config.getInt("app.width",WIDTH);
      HEIGHT=config.getInt("app.height",HEIGHT);
    }
    bgColor=TColor.newHex(config.getProperty("app.bgcolor","000000"));
    println(WIDTH+"x"+HEIGHT);
  }
  catch(IOException e) {
    println("couldn't load config");
    System.exit(1);
  }
  catch(NullPointerException e) {
    println("couldn't load config");
    System.exit(1);
  }
}

void initSeed() {
  String msg=config.getProperty("volume.seed.message","decode");
  PFont seedFont=loadFont("fonts/"+config.getProperty("volume.seed.font","VATheSansPlain-48.vlw"));
  int seedFontSize=config.getInt("volume.seed.font.size",48);
  int baseLine=config.getInt("volume.seed.font.baseline",50);
  seed=new SeedConfiguration(msg,seedFont,seedFontSize,baseLine);
}

void initLayers() {
  int numLayers=config.getInt("volume.layer.count",1);
  layers=new IsoLayerConfig[numLayers];
  for(int i=0; i<numLayers; i++) {
    layers[i]=new IsoLayerConfig(i);
    println(layers[i]);
  }
}

void initCamera() {
  cam=new CameraState();
  arcBall=new ArcBall(this);
}

void initExporters() {
  exporter=new FrameSequenceExporter("export","decode","tga");
  tiler=new Tiler(pgl,5);
}

void initShaders() {
  shader=new GLSLShader(pgl.gl);
  String name=config.getProperty("shader.name","glsl/phong_chromatic");
  shader.loadVertexShader(name+".vs");
  shader.loadFragmentShader(name+".fs");
  shader.useShaders();
  setFresnel(config.getFloat("shader.fresnel",5));
  setRefractRed(config.getFloat("shader.etaR",0.65));
  setRefractGreen(config.getFloat("shader.etaG",0.67));
  setRefractBlue(config.getFloat("shader.etaB",0.69));
}

void initColors() {
  int numCol=config.getInt("mesh.color.count",5);
  meshColors=new TColor[numCol];
  for(int i=0; i<numCol; i++) {
    meshColors[i]=TColor.newHex(config.getProperty("mesh.color"+i,"ffffff"));
  }
}

void initCameraPresets() {
  int numPresets=config.getInt("cam.preset.count",0);
  cameraPresets=new ArrayList();
  for(int i=0; i<numPresets; i++) {
    String prop="cam.preset"+i+".";
    String[] q=split(config.getProperty(prop+"quat","1,0,0,0"),",");
    Quaternion orient=new Quaternion(parseFloat(q[0]),parseFloat(q[1]),parseFloat(q[2]),parseFloat(q[3]));
    String[] p=split(config.getProperty(prop+"pos","0,0,0"),",");
    Vec3D pos=new Vec3D(parseFloat(p[0]),parseFloat(p[1]),parseFloat(p[2]));
    cameraPresets.add(new CameraPreset(orient,pos,config.getFloat(prop+"zoom",1)));
  }
}

public void stop() {
  super.stop();
  GLContext c=pgl.getContext();
  try {
    while (true) {
      try {
        if(c.makeCurrent() != GLContext.CONTEXT_NOT_CURRENT) {
          break;
        }
      } 
      catch(javax.media.opengl.GLException e) {
      }
      println("GL context not yet current...");
      Thread.sleep(10);
    }
  } 
  catch (InterruptedException e) {
    e.printStackTrace();
  }
  synchronized(c) {
    c.release();
    c.destroy();
  }
  println("context destroyed, applet stopped...");
}



