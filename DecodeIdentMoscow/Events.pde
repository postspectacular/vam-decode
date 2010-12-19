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

// this file only contains the various keyboard & mouse event listeners

void keyPressed() {
  if (keyCode == SHIFT) {
    isShiftDown = true;
  }
  if (keyCode == CONTROL) {
    isControlDown = true;
  }
  if (!uiMessage.isFocus()) {
    // this a trick to avoid having to check uppercase/lowercase letters
    char k=(char)(key | 0x20);
    if (k=='u' || keyCode==85) {
      doUpdate=!doUpdate;
    }
    if (k=='x') {
      rebuildMeshes();
    }
    if (k=='r') {
      toggleCamAutoRotation();
    }
    if (k=='l') {
      doUseLights=!doUseLights;
    }
    if (k=='n' && shader.isSupportedVS) {
      toggleNormals();
    }
    if (k=='c') {
      doUseGlobalCursor=!doUseGlobalCursor;
    }
    if (k=='h') {
      doShowUsage=!doShowUsage;
    }
    if (key=='-') {
      cam.targetZoom=max(cam.targetZoom-0.1,0.3);
    }
    if (key=='=') {
      cam.targetZoom=min(cam.targetZoom+0.1,4);
    }
    if (!online) {
      if (k=='t') {
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

