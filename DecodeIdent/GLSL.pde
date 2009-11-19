class GLSLShader {
  GL gl;
  int shaderID=-1;
  boolean isEnabledVS,isEnabledFS;
  boolean isSupportedVS,isSupportedFS;
  int vsID,fsID;

  GLSLShader(GL gl) {
    this.gl=gl;
    String extensions = gl.glGetString(GL.GL_EXTENSIONS);
    isSupportedVS = extensions.indexOf("GL_ARB_vertex_shader") != -1;
    isSupportedFS = extensions.indexOf("GL_ARB_fragment_shader") != -1;
    isEnabledVS = isSupportedVS;
    isEnabledFS = isSupportedFS;
    vsID=-1;
    fsID=-1;
  }

  void createProgramObject() {
    if (shaderID==-1 && isSupportedVS) {
      shaderID = gl.glCreateProgramObjectARB();
    }
  }

  void loadVertexShader(String file) {
    if (isSupportedVS) {
      createProgramObject();
      String shaderSource=join(loadStrings(file),"\n");
      vsID = gl.glCreateShaderObjectARB(GL.GL_VERTEX_SHADER_ARB);
      gl.glShaderSourceARB(vsID, 1, new String[]{
        shaderSource                                           }
      ,(int[]) null, 0);
      gl.glCompileShaderARB(vsID);
      checkLogInfo(vsID);
      gl.glAttachObjectARB(shaderID, vsID);
    }
  }

  void loadFragmentShader(String file) {
    if (isSupportedFS) {
      createProgramObject();
      String shaderSource=join(loadStrings(file),"\n");
      fsID = gl.glCreateShaderObjectARB(GL.GL_FRAGMENT_SHADER_ARB);
      gl.glShaderSourceARB(fsID, 1, new String[]{
        shaderSource
      }
      , (int[])null, 0);
      gl.glCompileShaderARB(fsID);
      checkLogInfo(fsID);
      gl.glAttachObjectARB(shaderID, fsID);
    }
  }

  int getAttribLocation(String name) {
    int attrib=-1;
    if (isSupportedVS) {
      attrib=gl.glGetAttribLocationARB(shaderID,name);
    }
    return attrib;
  }

  int getUniformLocation(String name) {
    int loc=-1;
    if (isSupportedVS) {
      loc=gl.glGetUniformLocationARB(shaderID,name);
    }
    return loc;
  }

  void useShaders() {
    if (isSupportedVS) {
      gl.glLinkProgramARB(shaderID);
      gl.glValidateProgramARB(shaderID);
      checkLogInfo(shaderID);
    }
  }

  void begin() {
    if (isSupportedVS) {
      gl.glUseProgramObjectARB(shaderID); 
    }
  }

  void end() {
    if (isSupportedVS) {
      gl.glUseProgramObjectARB(0);
    } 
  }

  void checkLogInfo(int id) {
    IntBuffer buf = BufferUtil.newIntBuffer(1);
    gl.glGetObjectParameterivARB(id, GL.GL_OBJECT_INFO_LOG_LENGTH_ARB, buf);
    int len = buf.get();
    if (len > 1) {
      ByteBuffer rawDesc = BufferUtil.newByteBuffer(len);
      byte[] descBytes = new byte[len];
      buf.flip();
      gl.glGetInfoLogARB(id, len, buf, rawDesc);
      rawDesc.get(descBytes);
      println("GLSL Error encountered: " + new String(descBytes));
    }
  }

  void setParameter(String id, int v) {
    int loc=getUniformLocation(id);
    if (loc!=-1) {
      gl.glUniform1iARB(loc,v);
    }
  }

  void setParameter(String id, float v) {
    int loc=getUniformLocation(id);
    if (loc!=-1) {
      gl.glUniform1fARB(loc,v);
    }
  }
}

