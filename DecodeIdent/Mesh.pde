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
 
class DecodeMesh {
  DecodeFace[] faces;
  DecodeVertex[] vertices;
  IsoLayerConfig layerConfig;
  IsoSurface surface;
  GLModel glModel;
  float[] glVerts, glNormals;

  int currFaceCount;

  DecodeMesh(IsoSurface surface, IsoLayerConfig layerConf) {
    this.surface=surface;
    this.layerConfig=layerConf;
    init();
  }

  void init() {
    TriangleMesh mesh = new TriangleMesh(layerConfig.name);
    surface.reset();
    surface.computeSurfaceMesh(mesh, layerConfig.isoValue);
    surface.computeSurfaceMesh(mesh, layerConfig.isoValue);
    mesh.center(null);
    mesh.computeVertexNormals();
    vertices=new DecodeVertex[mesh.vertices.size()];
    for(Iterator i=mesh.vertices.values().iterator(); i.hasNext();) {
      TriangleMesh.Vertex v=(TriangleMesh.Vertex)i.next();
      vertices[v.id]=new DecodeVertex(v);
    }
    faces=new DecodeFace[mesh.faces.size()];
    int idx=0;
    for(Iterator i=mesh.faces.iterator(); i.hasNext();) {
      TriangleMesh.Face f=(TriangleMesh.Face)i.next();
      faces[idx++]=new DecodeFace(vertices[f.a.id],vertices[f.b.id],vertices[f.c.id]);
    }
    glModel=new GLModel(app, faces.length*3, GLModel.TRIANGLES, GLModel.DYNAMIC);
    glModel.initNormals();
    // 3 vertices per face (alignment of 4 bytes)
    glVerts=new float[faces.length*12];
    glNormals=new float[glVerts.length];
    restart();
  }

  void restart() {
    Arrays.sort(faces,meshComparator);
    resetNormals();
    for(int i=0; i<glVerts.length; i++) {
      glVerts[i]=0;
    }
    currFaceCount=0;
  }

  void resetNormals() {
    for(int i=0,j=0; i<faces.length; i++,j+=12) {
      DecodeFace f=faces[i];
      glNormals[j]=f.va.v.normal.x;
      glNormals[j+1]=f.va.v.normal.y;
      glNormals[j+2]=f.va.v.normal.z;
      glNormals[j+4]=f.vb.v.normal.x;
      glNormals[j+5]=f.vb.v.normal.y;
      glNormals[j+6]=f.vb.v.normal.z;
      glNormals[j+8]=f.vc.v.normal.x;
      glNormals[j+9]=f.vc.v.normal.y;
      glNormals[j+10]=f.vc.v.normal.z;
    }
    glModel.updateNormals(glNormals);
  }
  
  void update() {
    if (layerConfig.isEnabled) {
      currFaceCount=min(currFaceCount+(int)(random(0.1,1)*meshBuildSpeed),faces.length);
      for (int i=0; i<vertices.length; i++) {
        vertices[i].update();
      }
    }
  }

  void displace() {
    for (int i=0; i<vertices.length; i++) {
      DecodeVertex v=vertices[i];
      float dist = abs(layerConfig.focus.x - v.v.x) / layerConfig.extrudeInfluenceWidth;
      float displace= 1+min(2,dist)*v.distortion.value;
      v.set(v.v.scale(1 + displace * 0.1f, displace, displace));
    }  
  }

  void explode(Vec3D cursor) {
    float amp=layerConfig.explodeAmpMod.update()*layerConfig.explodeAmp;
    for(int i=0; i<faces.length; i++) {
      faces[i].explode(cursor,amp);
    }
  }

  void render() {
    if (layerConfig.isEnabled) {
      for(int i=0,j=0; i<currFaceCount; i++,j+=12) {
        DecodeFace f=faces[i];
        glVerts[j]=f.a.x;
        glVerts[j+1]=f.a.y;
        glVerts[j+2]=f.a.z;
        glVerts[j+4]=f.b.x;
        glVerts[j+5]=f.b.y;
        glVerts[j+6]=f.b.z;
        glVerts[j+8]=f.c.x;
        glVerts[j+9]=f.c.y;
        glVerts[j+10]=f.c.z;
      }
      glModel.updateVertices(glVerts);
      if (doUpdateNormals) {
        Vec3D n=new Vec3D();
        for(int i=0,j=0; i<currFaceCount; i++,j+=12) {
          DecodeFace f=faces[i];
          if (shader.isSupportedVS) {
            n.set(f.a.sub(f.c).crossSelf(f.a.sub(f.b))).normalize();
          } else {
            n.set(f.c.sub(f.a).crossSelf(f.b.sub(f.a))).normalize();
          }
          glNormals[j]=n.x;
          glNormals[j+1]=n.y;
          glNormals[j+2]=n.z;
          //n.set(f.b).normalize();
          glNormals[j+4]=n.x;
          glNormals[j+5]=n.y;
          glNormals[j+6]=n.z;
          //n.set(f.c).normalize();
          glNormals[j+8]=n.x;
          glNormals[j+9]=n.y;
          glNormals[j+10]=n.z;
        }
        glModel.updateNormals(glNormals);
      }
      if (shader.isSupportedVS) {
        shader.begin();
        gl.glActiveTexture(GL.GL_TEXTURE0);
        gl.glBindTexture(GL.GL_TEXTURE_CUBE_MAP, textureIDs[layerConfig.textureID]);
        glModel.render();
        gl.glDisable(GL.GL_TEXTURE_CUBE_MAP);
        shader.end();
      } 
      else {
        gl.glMaterialfv(GL.GL_FRONT, GL.GL_DIFFUSE, meshColors[layerConfig.colorID].toRGBAArray(null), 0);
        fill(meshColors[layerConfig.colorID].toARGB());
        glModel.render();
      }
    }
  }

  void cleanup() {
    gl.glDeleteBuffers(1,glModel.vertCoordsVBO,0);
    gl.glDeleteBuffers(1,glModel.normCoordsVBO,0);
  }
}

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

  void explode(Vec3D focus,float amp) {
    centroid.set(va).addSelf(vb).addSelf(vc).scaleSelf(0.333);
    explodeDir.set(centroid).subSelf(focus);
    float newAmp=amp*(600/(explodeDir.magnitude()+0.0001));
    explodeAmp+=(newAmp-explodeAmp)*0.15;
    explodeDir.normalizeTo(explodeAmp);
    updateVertices();
  }
}





