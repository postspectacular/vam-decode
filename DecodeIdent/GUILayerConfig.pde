class GuiLayerConfig {
  IsoLayerConfig layer;
  int id;

  GuiLayerConfig(IsoLayerConfig l, ControlP5 ui, String tab, int i, int x, int y) {
    layer=l;
    id=i;

    Radio r;
    Slider s;
    Toggle t;
    
    t= ui.addToggle("toggleLayer"+i, layer.isEnabled, x, y, 14, 14);
    t.setId(id);
    t.setLabel("layer #"+(id+1));
    t.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.isEnabled=!layer.isEnabled;
        if (layer.isEnabled) {
          ((DecodeMesh)meshes.get(layer.id)).restart();
        }
      }
    }
    );
    t.setTab(tab);

    s=ui.addSlider("setIso"+i,0.01,5,layer.isoValue,x+60,y,100,14);
    s.setDecimalPrecision(4);
    s.setLabel("contour value");
    s.setTab(tab);
    s.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.isoValue=e.value();
        ((DecodeMesh)meshes.get(layer.id)).init();
      }
    }
    );
    
    s=ui.addSlider("cursorFreqX"+i,0,0.035,layer.cursorModX.frequency,x+250,y,100,14);
    s.setDecimalPrecision(4);
    s.setLabel("movement speed x");
    s.setTab(tab);
    s.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.cursorModX.frequency=e.value();
      }
    }
    );
    
    s=ui.addSlider("cursorFreqY"+i,0,0.035,layer.cursorModY.frequency,x+250,y+20,100,14);
    s.setDecimalPrecision(4);
    s.setLabel("movement speed y");
    s.setTab(tab);
    s.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.cursorModY.frequency=e.value();
      }
    }
    );
    
    s=ui.addSlider("explAmp"+i,0,40,layer.explodeAmp,x+450,y,100,14);
    s.setLabel("distortion");
    s.setTab(tab);
    s.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.explodeAmp=e.value();
      }
    }
    );
    
    s=ui.addSlider("explAmpfreq"+i,0,0.05,layer.explodeAmpMod.frequency,x+450,y+20,100,14);
    s.setDecimalPrecision(4);
    s.setLabel("distort freq");
    s.setTab(tab);
    s.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        layer.explodeAmpMod.frequency=e.value();
      }
    }
    );
    
    r=ui.addRadio("setTexture"+i,x+620,y);
    r.setBroadcast(false);
    String label=(shader.isSupportedVS ? "texture" : "color");
    for(int j=0; j<textureIDs.length; j++) {
      r.addItem(label+" #"+(j+1),j);
    }
    r.addListener(new ControlListener() {
      public void controlEvent(ControlEvent e) {
        if (shader.isSupportedVS) {
          layer.textureID=(int)e.value();
        } else {
          layer.colorID=(int)e.value();
        }
      }
    }
    );
    r.setBroadcast(true);
    r.setTab(tab);
  }
}

