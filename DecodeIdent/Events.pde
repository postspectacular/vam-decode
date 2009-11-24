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
    if (key=='l') {
      doUseLights=!doUseLights;
    }
    if (key=='n' && shader.isSupportedVS) {
      toggleNormals();
    }
    if (key=='c') {
      doUseGlobalCursor=!doUseGlobalCursor;
    }
    if (key=='-') {
      cam.targetZoom=max(cam.targetZoom-0.1,0.3);
    }
    if (key=='=') {
      cam.targetZoom=min(cam.targetZoom+0.1,4);
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
