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
 * This class handles the creation & manipulation of individual contour meshes extracted
 * from the volumetric version of the wordmark. It takes a preconfigured IsoSurface instance,
 * applies its configured contour value and then post-processes the created mesh by wrapping
 * each resulting vertex in a DecodeVertex and triangles in DecodeFace instances (see below).
 * 
 * For better performance the final mesh is stored as OpenGL Vertex Buffer Object directly
 * on the graphics card.
 */
class DecodeMesh {
  DecodeFace[] faces;
  DecodeVertex[] vertices;
  IsoLayerConfig layerConfig;
  IsoSurface surface;
  VBO vbo;
  float[] vboVertices, vboNormals;

  int currFaceCount;

  DecodeMesh(IsoSurface surface, IsoLayerConfig layerConf) {
    this.surface=surface;
    this.layerConfig=layerConf;
    init();
  }

  void init() {
    // create an empty mesh container
    TriangleMesh mesh = new TriangleMesh(layerConfig.name);
    // recompute the contour surface based on config settings
    surface.reset();
    surface.computeSurfaceMesh(mesh, layerConfig.isoValue);
    surface.computeSurfaceMesh(mesh, layerConfig.isoValue);
    // compute smoothened surface normal vectors
    mesh.computeVertexNormals();
    // now wrap all mesh vertices in a DecodeVertex instance
    vertices=new DecodeVertex[mesh.vertices.size()];
    for(Iterator i=mesh.vertices.values().iterator(); i.hasNext();) {
      TriangleMesh.Vertex v=(TriangleMesh.Vertex)i.next();
      vertices[v.id]=new DecodeVertex(v);
    }
    // do the same for faces using DecodeFace instances
    faces=new DecodeFace[mesh.faces.size()];
    int idx=0;
    for(Iterator i=mesh.faces.iterator(); i.hasNext();) {
      TriangleMesh.Face f=(TriangleMesh.Face)i.next();
      faces[idx++]=new DecodeFace(vertices[f.a.id],vertices[f.b.id],vertices[f.c.id]);
    }
    // create vertex buffer object for this mesh
    vbo=new VBO(faces.length*3);
    // 3 vertices per face (alignment of 4 bytes)
    vboVertices=new float[faces.length*12];
    vboNormals=new float[vboVertices.length];
    restart();
  }

  // resort all triangles based on currently chosen criteria
  // and reset active face count to slowly reveal the mesh again

  void restart() {
    Arrays.sort(faces,meshComparator);
    resetNormals();
    for(int i=0; i<vboVertices.length; i++) {
      vboVertices[i]=0;
    }
    currFaceCount=0;
  }

  // revert mesh normals to original state
  void resetNormals() {
    for(int i=0,j=0; i<faces.length; i++,j+=12) {
      DecodeFace f=faces[i];
      vboNormals[j]=-f.va.v.normal.x;
      vboNormals[j+1]=-f.va.v.normal.y;
      vboNormals[j+2]=-f.va.v.normal.z;
      vboNormals[j+4]=-f.vb.v.normal.x;
      vboNormals[j+5]=-f.vb.v.normal.y;
      vboNormals[j+6]=-f.vb.v.normal.z;
      vboNormals[j+8]=-f.vc.v.normal.x;
      vboNormals[j+9]=-f.vc.v.normal.y;
      vboNormals[j+10]=-f.vc.v.normal.z;
    }
    vbo.updateNormals(vboNormals);
  }

  // if layer is enabled, update all mesh vertices and reveal more faces
  void update() {
    if (layerConfig.isEnabled) {
      currFaceCount=min(currFaceCount+(int)(random(0.1,1)*meshBuildSpeed),faces.length);
      for (int i=0; i<vertices.length; i++) {
        vertices[i].update();
      }
    }
  }

  // only applied to outer layer, animates/extrudes individual vertices based
  // on sine waves and slowly moving focus point around which displacement is weakest
  void displace() {
    for (int i=0; i<vertices.length; i++) {
      DecodeVertex v=vertices[i];
      float dist = abs(layerConfig.focus.x - v.v.x) / layerConfig.extrudeInfluenceWidth;
      float displace= 1+min(2,dist)*v.distortion.value;
      v.set(v.v.scale(1 + displace * 0.1f, displace, displace));
    }  
  }

  // apply current explosion settings to all mesh triangles
  void explode(Vec3D cursor) {
    float amp=layerConfig.explodeAmpMod.update()*layerConfig.explodeAmp;
    for(int i=0; i<faces.length; i++) {
      faces[i].explode(cursor,amp);
    }
  }

  // updates vertex positions in VBO object on graphics card
  // and then triggers rendering in one go

  void render() {
    if (layerConfig.isEnabled) {
      for(int i=0,j=0; i<currFaceCount; i++,j+=12) {
        DecodeFace f=faces[i];
        vboVertices[j]=f.a.x;
        vboVertices[j+1]=f.a.y;
        vboVertices[j+2]=f.a.z;
        vboVertices[j+4]=f.b.x;
        vboVertices[j+5]=f.b.y;
        vboVertices[j+6]=f.b.z;
        vboVertices[j+8]=f.c.x;
        vboVertices[j+9]=f.c.y;
        vboVertices[j+10]=f.c.z;
      }
      vbo.updateVertices(vboVertices);
      if (doUpdateNormals && doUpdate) {
        Vec3D n=new Vec3D();
        for(int i=0,j=0; i<currFaceCount; i++,j+=12) {
          DecodeFace f=faces[i];
          if (shader.isSupportedVS) {
            n.set(f.a.sub(f.b).crossSelf(f.a.sub(f.c))).normalize();
          } 
          else {
            n.set(f.a.sub(f.c).crossSelf(f.a.sub(f.b))).normalize(); 
          }
          vboNormals[j]=n.x;
          vboNormals[j+1]=n.y;
          vboNormals[j+2]=n.z;
          vboNormals[j+4]=n.x;
          vboNormals[j+5]=n.y;
          vboNormals[j+6]=n.z;
          vboNormals[j+8]=n.x;
          vboNormals[j+9]=n.y;
          vboNormals[j+10]=n.z;
        }
        vbo.updateNormals(vboNormals);
      }
      if (shader.isSupportedVS) {
        shader.begin();
        gl.glActiveTexture(GL.GL_TEXTURE0);
        gl.glBindTexture(GL.GL_TEXTURE_CUBE_MAP, textureIDs[layerConfig.textureID]);
        vbo.render();
        gl.glDisable(GL.GL_TEXTURE_CUBE_MAP);
        shader.end();
      } 
      else {
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_DIFFUSE, meshColors[layerConfig.colorID].toRGBAArray(null), 0);
        fill(meshColors[layerConfig.colorID].toARGB());
        vbo.render();
      }
    }
  }

  // frees up all mesh resources on the graphics card
  // called when rebuilding meshes
  void cleanup() {
    vbo.cleanup();
  }
}

/**
 * This is a simple wrapper for a mesh vertex which supplements it
 * with a modulation wave used to create extrusion effects
 */
class DecodeVertex extends Vec3D {
  TriangleMesh.Vertex v;
  AbstractWave distortion;

  DecodeVertex(TriangleMesh.Vertex v) {
    super(v);
    this.v=v;
    float amp=random(1)<0.18 ? random(random(1)<0.8 ? 0.75 : 1.5) : 
    0;
    distortion=new SineWave(0,random(0.01,0.05),amp,amp/2);
  }

  void update() {
    distortion.update();
  }
}

/**
 * Wrapper for a mesh triangle. Stores original vertices and additional vectors
 * to store current/exploded positions of the triangle points.
 */
class DecodeFace {
  final Vec3D a,b,c,explodeDir,centroid;
  float explodeAmp;
  final DecodeVertex va,vb,vc;

  DecodeFace(DecodeVertex va, DecodeVertex vb, DecodeVertex vc) {
    this.va=va;
    this.vb=vb;
    this.vc=vc;
    this.a=new Vec3D();
    this.b=new Vec3D();
    this.c=new Vec3D();
    centroid=va.add(vb).addSelf(vc).scaleSelf(0.333);
    explodeDir=centroid.copy();
    updateVertices();
  }

  void updateVertices() {
    a.set(va).addSelf(explodeDir);
    b.set(vb).addSelf(explodeDir);
    c.set(vc).addSelf(explodeDir);

  }

  // applies explosion to all 3 corner points
  // explosion direction & amount is based on the current centroid
  // of the triangle and its distance to the explosion epicentre
  
  void explode(Vec3D focus,float amp) {
    centroid.set(va).addSelf(vb).addSelf(vc).scaleSelf(0.333);
    explodeDir.set(centroid).subSelf(focus);
    float newAmp=amp*(600/(explodeDir.magnitude()+0.0001));
    explodeAmp+=(newAmp-explodeAmp)*0.15;
    explodeDir.normalizeTo(explodeAmp);
    updateVertices();
  }
}

