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
 
class FaceFuzzyXComparator implements Comparator {
  
  float fuzzy;
  
  public FaceFuzzyXComparator(float fuzzy) {
    this.fuzzy=fuzzy;
  }
  
  public int compare(Object a, Object b) {
    if (random(1)<fuzzy) {
      return (int)random(-2,2);
    } else {
      return (int)(((DecodeFace)a).centroid.x-((DecodeFace)b).centroid.x);
    }
  }
}

class FaceDistanceComparator implements Comparator {
  
  Vec3D origin;
  float fuzzy;
  
  public FaceDistanceComparator(Vec3D origin, float fuzzy) {
    this.origin=origin;
    this.fuzzy=fuzzy;
  }
  
  public int compare(Object a, Object b) {
    if (random(1)<fuzzy) {
      return (int)random(-2,2);
    } else {
      return (int)(((DecodeFace)a).centroid.distanceToSquared(origin)-((DecodeFace)b).centroid.distanceToSquared(origin));
    }
  }
}

class SpringyPoint extends Vec3D {
  Vec3D velocity=new Vec3D();
  float damping,smoothing;
  
  SpringyPoint(float x, float y, float z, float d, float s) {
    super(x,y,z);
    damping=d;
    smoothing=s;
  }
  
  void update(Vec3D target) {
    velocity.set(velocity.scale(damping).addSelf(target.sub(this).scaleSelf(smoothing)));
    this.addSelf(velocity);
  }
}
