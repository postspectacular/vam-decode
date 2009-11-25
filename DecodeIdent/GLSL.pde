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
 * This class is a barebones wrapper for a GLSL shader pair.
 * All shader update methods are checked for availability in order to avoid
 * OpenGL errors and to free the main app from having to do those checks.
 */
class GLSLShader {
  final GL gl;
  final boolean isSupportedVS;
  final boolean isSupportedFS;
  int vsID,fsID;
  int shaderID=-1;

  public GLSLShader(GL gl) {
    this.gl=gl;
    String extensions = gl.glGetString(GL.GL_EXTENSIONS);
    isSupportedVS = extensions.indexOf("GL_ARB_vertex_shader") != -1;
    isSupportedFS = extensions.indexOf("GL_ARB_fragment_shader") != -1;
    vsID=-1;
    fsID=-1;
  }

  protected void createProgramObject() {
    if (shaderID==-1 && isSupportedVS) {
      shaderID = gl.glCreateProgramObjectARB();
    }
  }

  private int initFromFile(int type, String file) {
    createProgramObject();
    String src=new String(loadBytes(file));
    int id = gl.glCreateShaderObjectARB(type);
    gl.glShaderSourceARB(id, 1, new String[]{ 
      src     }
    , null, 0);
    gl.glCompileShaderARB(id);
    checkErrorLog(id);
    gl.glAttachObjectARB(shaderID, id);
    return id;
  }

  public void loadVertexShader(String file) {
    if (isSupportedVS) {
      vsID=initFromFile(GL.GL_VERTEX_SHADER_ARB,file);
    }
  }

  public void loadFragmentShader(String file) {
    if (isSupportedFS) {
      fsID=initFromFile(GL.GL_FRAGMENT_SHADER_ARB,file);
    }
  }

  public int getAttribLocation(String name) {
    int attrib=-1;
    if (isSupportedVS) {
      attrib=gl.glGetAttribLocationARB(shaderID,name);
    }
    return attrib;
  }

  public int getUniformLocation(String name) {
    int loc=-1;
    if (isSupportedVS) {
      loc=gl.glGetUniformLocationARB(shaderID,name);
    }
    return loc;
  }

  public void useShaders() {
    if (isSupportedVS) {
      gl.glLinkProgramARB(shaderID);
      gl.glValidateProgramARB(shaderID);
      checkErrorLog(shaderID);
    }
  }

  public void begin() {
    if (isSupportedVS) {
      gl.glUseProgramObjectARB(shaderID); 
    }
  }

  public void end() {
    if (isSupportedVS) {
      gl.glUseProgramObjectARB(0);
    } 
  }

  public void checkErrorLog(int id) {
    IntBuffer buf = BufferUtil.newIntBuffer(1);
    gl.glGetObjectParameterivARB(id, GL.GL_OBJECT_INFO_LOG_LENGTH_ARB, buf);
    int len = buf.get();
    if (len > 1) {
      ByteBuffer rawDesc = BufferUtil.newByteBuffer(len);
      byte[] descBytes = new byte[len];
      buf.flip();
      gl.glGetInfoLogARB(id, len, buf, rawDesc);
      rawDesc.get(descBytes);
      println("GLSL error encountered: " + new String(descBytes));
    }
  }

  public void setParameter(String id, int v) {
    int loc=getUniformLocation(id);
    if (loc!=-1) {
      gl.glUniform1iARB(loc,v);
    }
  }

  public void setParameter(String id, float v) {
    int loc=getUniformLocation(id);
    if (loc!=-1) {
      gl.glUniform1fARB(loc,v);
    }
  }
}

