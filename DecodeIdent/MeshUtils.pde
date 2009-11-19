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
