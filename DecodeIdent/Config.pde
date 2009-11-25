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
 * The seed configuration class stores the actual wordmark text and
 * font settings used for rendering it
 */
class SeedConfiguration {
  String message;
  PFont font;
  int fontSize;
  int baseLine;

  SeedConfiguration(String m, PFont f, int fs, int bl) {
    setMessage(m);
    font=f;
    fontSize=fs;
    baseLine=bl;
  }

  void setMessage(String m) {
    message=m.toUpperCase();
  }
}

/**
 * This class defines all parameters for an individual contour layer.
 * The constructor parses its settings from the given config file. The class
 * itself is mainly used for generating the GUI and DecodeMesh instances.
 */
class IsoLayerConfig {
  int id;
  String name;
  ExtrudeFocus focus;
  float explodeAmp;
  float extrudeInfluenceWidth;
  float isoValue;
  boolean isEnabled=true;
  int textureID;
  int colorID;

  AbstractWave explodeAmpMod;

  Vec3D explodeCursor;
  AbstractWave cursorModX,cursorModY;

  IsoLayerConfig(int id) {
    this.id=id;
    String baseProp="volume.layer"+id+".";
    isoValue=config.getFloat(baseProp+"iso",0.2);
    textureID=config.getInt(baseProp+"texture",0);
    colorID=config.getInt(baseProp+"color",0);
    focus=new ExtrudeFocus(config.getFloat(baseProp+"focus.x",0),config.getFloat(baseProp+"focus.speed",1),config.getFloat(baseProp+"focus.min",-volume.getScale().x),config.getFloat(baseProp+"focus.max",volume.getScale().x));
    extrudeInfluenceWidth=config.getFloat(baseProp+"displace.width",400);
    explodeAmp=config.getFloat(baseProp+"explode.amp",10);
    explodeAmpMod=new SineWave(0,random(0.015,0.03),2,2);
    explodeCursor=new Vec3D();
    cursorModX=new SineWave(0,random(0.005,0.02),250,0);
    cursorModY=new SineWave(0,random(0.005,0.02),50,0);
    name="layer "+isoValue;
  }

  void update() {
    focus.update();
    explodeCursor.set(cursorModX.update(),cursorModY.update(),0);
  }

  String toString() {
    return "layer"+id+": "+focus+" iso: "+isoValue+" dist: "+explodeAmp+" tex: "+textureID;
  }

  void setWaveformX(int waveID) {
    float freq=random(0.005,0.015);
    switch(waveID) {
    case 0:
      cursorModX=new SineWave(0,freq,1000,0);
      break;
    case 1:
      cursorModX=new FMSawtoothWave(0,freq,1000,0);
      break;
    }
  }
}

/**
 * Defines a 1-dimensional, moving focus point used for
 * extruding vertices on the outermost mesh layer (to create spikes).
 */
class ExtrudeFocus {
  float x,speed,min,max;

  ExtrudeFocus(float x, float speed, float min, float max) {
    this.x=x;
    this.speed=speed;
    this.min=min;
    this.max=max;
  }

  void update() {
    x+=speed;
    if (x<min) {
      x=max+(x-min);
    } 
    else if (x>max) {
      x=min+x-max;
    }
  }

  String toString() {
    return x+", "+speed+" bounds: "+min+"->"+max;
  }
}

