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
 * Tile based frame exporter for saving super high resolution images, based on
 * code by Marius Watz. This is a simplified version and adds support for
 * different view angles (FOV) and clipping planes. Based on the number of tiles
 * used each frame will be rendered in slices several times and the main
 * application must ensure that no parameters are changed during this process as
 * else visible seams will appear in the exported image. The resulting image
 * size is numTiles the size of the current window size. The individual
 * slices/tiles are stitched together in a large offscreen buffer. The maximum
 * image size depends on the available RAM and it's the user's responsibility to
 * ensure enough memory is available.
 * 
 * @author Karsten Schmidt (2008)
 * @author Marius Watz (2007)
 */
class Tiler {

  protected PGraphics3D gfx;
  protected PImage buffer;
  protected Vec2D[] tileOffsets;

  protected double normTileSize;
  protected double aspect;
  protected int numTiles;

  protected int tileID;
  protected float subTileID;

  protected boolean isTiling;
  protected String fileName;
  protected String format;
  protected double cameraFOV;
  protected double cameraX;
  protected double cameraY;
  protected double cameraZ;
  protected double cameraFar;
  protected double cameraNear;
  public double top;
  public double bottom;
  public double left;
  public double right;
  protected Vec2D tileSize;

  public Tiler(PGraphics3D g, int n) {
    gfx = g;
    numTiles = n;
  }

  protected void chooseTile(int id) {
    Vec2D o = tileOffsets[id];
    gfx.frustum(o.x, o.x + tileSize.x, o.y, o.y + tileSize.y,
    (float) cameraNear, (float) cameraFar);
  }

  /**
   * Setup the exporter based on the given view properties.
   * 
   * @param fov
   *            vertical field of view in radians
   * @param near
   *            z coordinate of near clipping plane
   * @param far
   *            z coordinate of far clipping plane
   */
  public void initTiles(float fov, float near, float far) {
    tileOffsets = new Vec2D[numTiles * numTiles];
    aspect = (double) gfx.width / gfx.height;
    cameraFOV = fov;
    cameraNear = near;
    cameraFar = far;
    top = Math.tan(cameraFOV * 0.5) * cameraNear;
    bottom = -top;
    left = aspect * bottom;
    right = aspect * top;
    int idx = 0;
    tileSize =
      new Vec2D((float) (2 * right / numTiles),
    (float) (2 * top / numTiles));
    double y = top - tileSize.y;
    while (idx < tileOffsets.length) {
      double x = left;
      for (int xi = 0; xi < numTiles; xi++) {
        tileOffsets[idx++] = new Vec2D((float) x, (float) y);
        x += tileSize.x;
      }
      y -= tileSize.y;
    }
  }

  /**
   * Returns the state of the export.
   * 
   * @return true, if tiling export is in progress
   */
  public boolean isTiling() {
    return isTiling;
  }

  /**
   * Post-processes the current frame. This method needs to be called at the
   * end of each rendering loop.
   */
  public void post() {
    if (isTiling) {
      subTileID++;
      if (subTileID == 2) {
        int x = tileID % numTiles;
        int y = tileID / numTiles;
        gfx.loadPixels();
        buffer.set(x * gfx.width, y * gfx.height, gfx);
        if (tileID == tileOffsets.length - 1) {
          buffer.save(fileName + "_" + buffer.width + "x"
            + buffer.height + "." + format);
          buffer = null;
        }
        subTileID = 0;
        isTiling = (++tileID < tileOffsets.length);
      }
    }
  }

  /**
   * If tiling is currently active, this method initializes the custom
   * perspective transformations. Needs to be called at the very beginning of
   * each render loop.
   */
  public void pre() {
    if (isTiling) {
      chooseTile(tileID);
    }
  }

  /**
   * Starts tiling process. User needs to ensure that
   * {@link #initTiles(float, float, float)} has been called at least once
   * previously.
   * 
   * @param path
   *            absolute path to export folder
   * @param baseName
   *            base filename without extension
   * @param format
   *            file extension/type
   */
  public void save(String path, String baseName, String format) {
    isTiling = false;
    (new File(path)).mkdirs();
    this.fileName = path + "/" + baseName;
    this.format = format;
    buffer = new PImage(gfx.width * numTiles, gfx.height * numTiles);
    tileID = 0;
    subTileID = 0;
    isTiling = true;
  }
}

