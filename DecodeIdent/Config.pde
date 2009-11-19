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
    explodeAmpMod=new SineWave(0,random(0.005,0.02),2,2);
    explodeCursor=new Vec3D(-500,0,0);
    cursorModX=new SineWave(0,random(0.005,0.015),500,0);
    cursorModY=new SineWave(0,random(0.005,0.02),200,0);
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
