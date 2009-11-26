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
import toxi.volume.*;
import toxi.util.datatypes.*;
import toxi.math.*;
import toxi.math.waves.*;
import toxi.math.conversion.*;
import toxi.geom.*;
import toxi.geom.util.*;

import controlP5.*;

// type & variable declarations

TypedProperties config;
public SeedConfiguration seed;

// window settings
int WIDTH=960;
int HEIGHT=540;
public TColor bgColor,targetBgColor;

public PApplet app;
public PGraphicsOpenGL pgl;
public GL gl;
public GLSLShader shader;

// images for background gradient & wordmark
public PImage bgGradient;
public PGraphics seedImg;

// volumetric types
public VolumetricSpace volume;
public IsoSurface surface;
public VolumetricBrush brush;

// mesh containers & colours
public ArrayList meshes;
public TColor[] meshColors;
public SpringyPoint explodeCursor=new SpringyPoint(0,0,0,0.83,0.1);

// contour layer definitions
public IsoLayerConfig[] layers;

// bitmap exporters
public Tiler tiler;
public FrameSequenceExporter exporter;

// view settings
public CameraState cam;
public ArrayList cameraPresets;
public ArcBall arcBall;

// application & interface switches
public boolean doUpdate=true;
public boolean doUseLights=true;
public boolean doUseGlobalCursor=false;
public boolean doUpdateNormals=true;
public boolean doShowGradient=true;
public boolean doShowUsage=true;

public boolean isShiftDown=false;
public boolean isControlDown = false;

// default values
public int MAX_CAM_PRESETS = 9;
public int numExportTiles=3;
public int meshBuildSpeed=33;
public float meshFuzziness=0.1;
public float bgGradientAlpha=1;
public float targetGradAlpha=1;

public Comparator meshComparator=new FaceDistanceComparator(new Vec3D(),meshFuzziness);
public String[] usage;

// initialization method
// loads config file, creates window and initializes all app components

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

// application main loop
// handles all mesh updates & rendering tasks

void draw() {
  // check if tile exporter is currently active
  // and only updates view & meshes if it's not
  if (!tiler.isTiling()) {
    cam.update();
    updateLayers();
    updateMeshes();
  }
  // apply field of view
  cam.setPerspective();
  bgColor.blend(targetBgColor,0.02);
  bgGradientAlpha+=(targetGradAlpha-bgGradientAlpha)*0.02;
  background(bgColor.toARGB());
  // move into 3D coordinate system
  pushMatrix();
  translate(width/2,height/2,0);
  // apply arc ball view orientation & current camera settings
  arcBall.apply();
  cam.apply();
  // if active, prepare tile exporter
  tiler.pre();
  // check if we need to draw background gradient
  if (doShowGradient) {
    drawBackground();
  }
  // switch into OpenGL mode
  pgl.beginGL();
  // apply lights
  if (doUseLights) {
    if (!shader.isSupportedVS) {
      lights();
      gl.glEnable(GL.GL_LIGHTING);
    } 
    else {
      initLights();
    }
  }
  // render all enabled meshes
  // (meshes check themselves if they're active)
  for(Iterator i=meshes.iterator(); i.hasNext();) {
    DecodeMesh mesh=(DecodeMesh)i.next();
    mesh.render();
  }
  pgl.endGL();
  // if tile exporter is active, post-process current frame
  tiler.post();
  // if image sequence exporter is active, export current frame
  // and show current time stamp in the "export" UI tab
  if (exporter.isExporting()) {
    exporter.update();
    uiLabelTimecode.setValue("recording: "+exporter.getTimeCode());
  }
  // revert into 2D coordinate system
  popMatrix();
  noLights();
  gl.glDisable(GL.GL_LIGHTING);
  imageMode(CORNER);
  hint(DISABLE_DEPTH_TEST);
  // display usage information
  showInfo();
}

// draw background gradient

void drawBackground() {
  hint(DISABLE_DEPTH_TEST);
  imageMode(CENTER);
  tint(255,bgGradientAlpha*255);
  image(bgGradient,0,0,2048,2048);
  noTint();
  hint(ENABLE_DEPTH_TEST);
}

// update all layer configurations

void updateLayers() {
  for(int i=0; i<layers.length; i++) {
    layers[i].update();
  }
}

// update all meshes based on current layer configs

void updateMeshes() {
  // vertex extrusion is only applied to the outermost layer
  // i.e. the one with the lowest contour/iso value
  DecodeMesh m=(DecodeMesh)meshes.get(0);
  m.displace();
  // if right mouse button is presses, update position of explosion focal point
  if(mousePressed && mouseButton==RIGHT) {
    doUseGlobalCursor=true;
    explodeCursor.update(new Vec3D(-(width/2-mouseX)*1.5,-(height/2-mouseY)*1.5,0));
  }
  // update mesh triangle explosions based on current focal point(s)
  if(doUpdate) {
    for(Iterator i=meshes.iterator(); i.hasNext();) {
      DecodeMesh mesh=(DecodeMesh)i.next();
      mesh.update();
      mesh.explode(doUseGlobalCursor ? explodeCursor : m.layerConfig.explodeCursor);
    }
  }
}

// if the "present" UI tab is currently active,
// display usage info taken from config file

void showInfo() {
  if (selectedTabName.equalsIgnoreCase("default")) {
    textFont(seed.font);
    textSize(12);
    textAlign(LEFT);
    if (doShowUsage) {
      int leading=16;
      int x=20;
      int y=height-usage.length*leading;
      for(int i=0; i<usage.length; i++) {
        if (usage[i].length()>0) {
          fill(0,160);
          rect(0,y-leading,textWidth(usage[i])+x+10,leading);
          fill(255);
          text(usage[i],x,y-4);
        }
        y+=leading;
      }
    }
  }
}

// load the configuration file
// depending on the runtime context of the application
// the path to this file is either assumed to be in the
// config subfolder (offline) or defined via the "decode.config"
// applet parameter when running in the browser.
//
// This method creates an instance of the configuration used
// throughout other parts of the application, but for now only captures
// the window dimensions and default background colour.
//
// If the config file can't be loaded, the application immediately exits.
//
// For a description of the various other configuration parameters
// please consult the user guid on the project wiki:
// http://code.google.com/p/decode/wiki/UserGuideConfig

void initConfig() {
  InputStream stream;
  // TypedProperties is a utility class from the toxiclibs package
  // and provides easy access to working with external properties
  config=new TypedProperties();
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
    } 
    else {
      WIDTH=config.getInt("app.width",WIDTH);
      HEIGHT=config.getInt("app.height",HEIGHT);
    }
    bgColor=TColor.newHex(config.getProperty("app.bgcolor","000000"));
    targetBgColor=bgColor.copy();
    doShowUsage=config.getBoolean("app.usage.enabled",doShowUsage);
    usage=loadStrings(sketchPath(config.getProperty("app.usage.file")));
  }
  catch(IOException e) {
  }
  catch(NullPointerException e) {
  }
  if (config==null) {
    println("couldn't load config");
    System.exit(1);
  }
}

// Initializes the default wordmark & font settings

void initSeed() {
  String msg=config.getProperty("volume.seed.message","decode");
  PFont seedFont=loadFont("fonts/"+config.getProperty("volume.seed.font","VATheSansPlain-48.vlw"));
  int seedFontSize=config.getInt("volume.seed.font.size",48);
  int baseLine=config.getInt("volume.seed.font.baseline",50);
  seed=new SeedConfiguration(msg,seedFont,seedFontSize,baseLine);
}

// Extracts & initializes all contour layer definitions
// from the config file

void initLayers() {
  int numLayers=config.getInt("volume.layer.count", 1);
  layers=new IsoLayerConfig[numLayers];
  for(int i=0; i<numLayers; i++) {
    layers[i]=new IsoLayerConfig(i);
    println(layers[i]);
  }
}

// initializes the actual polygon meshes from the
// volumetric version of the wordmark

void initMeshes() {
  if (meshes!=null) {
    for(Iterator i=meshes.iterator(); i.hasNext();) {
      ((DecodeMesh)i.next()).cleanup();
    }
  }
  meshes=new ArrayList();
  for(int i=0; i<layers.length; i++) {
    IsoLayerConfig lc=layers[i];
    DecodeMesh dm=new DecodeMesh(surface, lc);
    meshes.add(dm);
  }
}

// initializes camera/view objects

void initCamera() {
  cam=new CameraState();
  arcBall=new ArcBall(this);
}

// initializes the bitmap exporters

void initExporters() {
  exporter=new FrameSequenceExporter("export","decode","tga");
  tiler=new Tiler(pgl,5);
}

// attempts to load & initialize the GLSL
// vertex & pixel shaders and their default settings
// see the user guide for more information about the
// shaders used:
// http://code.google.com/p/decode/wiki/DevGuideShader

void initShaders() {
  shader=new GLSLShader(pgl.gl);
  String name=config.getProperty("shader.name","glsl/phong_chromatic");
  shader.loadVertexShader(name+".vs");
  shader.loadFragmentShader(name+".fs");
  shader.useShaders();
  setFresnel(config.getFloat("shader.fresnel", 5));
  setRefractRed(config.getFloat("shader.etaR", 0.65));
  setRefractGreen(config.getFloat("shader.etaG", 0.67));
  setRefractBlue(config.getFloat("shader.etaB", 0.69));
}

// in case the graphics card doesn't support shaders
// the meshes will be tinted in plain colours
// default colours are defined in the config file, but
// can be randomized via the user interface

void initColors() {
  int numCol=config.getInt("mesh.color.count",5);
  meshColors=new TColor[numCol];
  for(int i=0; i<numCol; i++) {
    meshColors[i]=TColor.newHex(config.getProperty("mesh.color"+i, "ffffff"));
  }
}

// load pre-defined camera presets from config file
// and store them in CameraPreset objects (defined in the Camera.pde)

void initCameraPresets() {
  int numPresets=config.getInt("cam.preset.count",0);
  cameraPresets=new ArrayList();
  for(int i=0; i<numPresets; i++) {
    String baseProp="cam.preset"+i+".";
    float[] q=config.getFloatArray(baseProp+"quat", new float[] {
      1, 0, 0, 0             }
    );
    Quaternion orient=new Quaternion(q[0], q[1], q[2], q[3]);
    float[] p=config.getFloatArray(baseProp+"pos", new float[] { 
      0, 0, 0             }
    );
    Vec3D pos=new Vec3D(p[0], p[1], p[2]);
    TColor bg=null;
    String hexCol=config.getProperty(baseProp+"bg", null);
    if (hexCol!=null) {
      bg=TColor.newHex(hexCol);
    }
    cameraPresets.add(new CameraPreset(orient, pos, config.getFloat(baseProp+"zoom", 1), bg, 1));
  }
}


