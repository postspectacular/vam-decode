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
  public float maxModAmpY = radians(60);

  public CameraState() {
    camModX = new SineWave(PI, 0.01f, 0, 0);
    camModY = new SineWave(0, 0.004f, 0, 0);
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

  CameraPreset(Quaternion orient, Vec3D pos, float zoom) {
    set(orient,pos,zoom);
  }
  
  void activate() {
    arcBall.targetOrientation.set(orient);
    cam.targetPos.set(pos);
    cam.targetZoom=zoom;
  }
  
  void set(Quaternion orient, Vec3D pos, float zoom) {
    this.orient=orient.copy();
    this.pos=pos.copy();
    this.zoom=zoom;
  }
}

