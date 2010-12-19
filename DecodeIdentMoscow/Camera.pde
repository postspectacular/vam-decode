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
 
public class CameraState {

  public final Vec3D pos = new Vec3D();
  public final Vec3D targetPos = new Vec3D();

  public float zoomSmooth = 0.025f;
  public float panSmooth = 0.25f;
  public float targetZoom = 1f;
  public float zoom = 1;

  public float fov = MathUtils.DEG2RAD * 60;
  public float near = 1;
  public float far = 6000;

  public boolean isCamModEnabled;

  private AbstractWave camModX, camModY;

  public float maxModAmpX = radians(15);
  public float maxModAmpY = radians(30);

  public CameraState() {
    camModX = new SineWave(PI, 0.02f, 0, 0);
    camModY = new SineWave(0, 0.0083f, 0, 0);
  }

  public void apply() {
    rotateX(camModX.value);
    rotateY(camModY.value);
    scale(zoom);
    translate(pos.x, pos.y, pos.z);
  }

  public void enableModulation(boolean state) {
    isCamModEnabled = state;
  }

  public void toggleModulation() {
    isCamModEnabled=!isCamModEnabled;
  }

  public void setPerspective() {
    perspective(fov, (float) width / height, near, far);
  }

  public void update() {
    pos.interpolateToSelf(targetPos, panSmooth);
    zoom += (targetZoom - zoom) * zoomSmooth;
    if (isCamModEnabled) {
      camModX.amp += (maxModAmpX - camModX.amp) * 0.25;
      camModY.amp += (maxModAmpY - camModY.amp) * 0.25;
    } 
    else {
      camModX.amp *= 0.9;
      camModY.amp *= 0.9;
    }
    camModX.update();
    camModY.update();
  }
}

class CameraPreset {
  Quaternion orient;
  Vec3D pos;
  float zoom;
  TColor bg;
  float gradAlpha;
  
  CameraPreset(Quaternion orient, Vec3D pos, float zoom, TColor bg, float a) {
    set(orient,pos,zoom,bg,a);
  }
  
  void activate() {
    arcBall.targetOrientation.set(orient);
    cam.targetPos.set(pos);
    cam.targetZoom=zoom;
    targetGradAlpha=gradAlpha;
    if (bg!=null) {
      targetBgColor=bg.copy();
    }
  }
  
  void set(Quaternion orient, Vec3D pos, float zoom, TColor bg, float a) {
    this.orient=orient.copy();
    this.pos=pos.copy();
    this.zoom=zoom;
    this.gradAlpha=a;
    if (bg!=null) {
      this.bg=bg.copy();
    }
  }
}

