void keyPressed() {
  if (keyCode == SHIFT) {
    isShiftDown = true;
  }
  if (keyCode == CONTROL) {
    isControlDown = true;
  }
  if (!uiMessage.isFocus()) {
    if (key=='u' || keyCode==85) {
      doUpdate=!doUpdate;
    }
    if (key=='x') {
      rebuildMeshes();
    }
    if (key=='r') {
      toggleCamAutoRotation();
    }
    if (!online) {
      if (key=='t') {
        saveTiles();
      }
      if (key==' ') {
        toggleExport();
      }
    }
    if (key>='1' && key<'1'+cameraPresets.size()) {
      setCameraPreset(key-'1');
    } 
  }
}

void keyReleased() {
  if (keyCode == SHIFT) {
    isShiftDown = false;
  }
  if (keyCode == CONTROL) {
    isControlDown = false;
  }
}

void mousePressed() {
  if (isShiftDown) {
    arcBall.mousePressed();
  }
}

void mouseDragged() {
  if (isShiftDown) {
    arcBall.mouseDragged();
  }
}

void mouseReleased() {
  arcBall.mouseReleased();
}
