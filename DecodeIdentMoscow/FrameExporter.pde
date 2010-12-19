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
 
import java.text.DecimalFormat;

/**
 * This class handles the exporting of individual frames in a chosen file
 * format. A subfolder is created automatically for each new session/sequence.
 */
class FrameSequenceExporter {

  protected String basePath;
  protected String baseName;
  protected String format;
  protected String sessionPath;
  protected long sessionID;
  public int sequenceID;

  protected boolean isActive;
  protected DecimalFormat frameIDFormat;
  protected DecimalFormat timeCodeFormat;
  protected int fps;

  public FrameSequenceExporter(String basePath, String baseName, String format) {
    super();
    this.basePath = basePath;
    this.baseName = baseName;
    this.format = format;
    setSequenceFormat(5);
    setFPS(25);
    timeCodeFormat = new DecimalFormat("00");
  }

  /**
   * Returns the currently set file format extension
   * 
   * @return file format
   */
  public String getFileFormat() {
    return format;
  }

  /**
   * Returns the currently set frame rate.
   * 
   * @return the fps
   */
  public int getFPS() {
    return fps;
  }

  /**
   * Returns a mm:ss:ff formatted version of the current frame ID, based on
   * the currently set frame rate.
   * 
   * @return formatted time code
   */
  public String getTimeCode() {
    return timeCodeFormat.format(sequenceID / fps / 60) + ":"
      + timeCodeFormat.format(sequenceID / fps) + ":"
      + timeCodeFormat.format(sequenceID % fps);
  }

  /**
   * Returns status, if exporter is currently active
   * 
   * @return true, if active
   */
  public boolean isExporting() {
    return isActive;
  }

  /**
   * Starts a new export session using the current timestamp as session ID.
   * 
   * @return true, if the session initialized properly
   */
  public boolean newSession() {
    return newSession(System.currentTimeMillis() / 1000);
  }

  /**
   * Starts a new export session using the given session ID. A subfolder for
   * this session is automatically created under the base path specified for
   * the constructor.
   * 
   * @param id
   *            session ID
   * @return true, if the session initialized properly
   */
  public boolean newSession(long id) {
    sessionID = id;
    sequenceID = 0;
    sessionPath = basePath + "/" + sessionID + "/";
    return (new File(sessionPath)).mkdirs();
  }

  /**
   * Sets new file format extension. Supported formats are: {@link #FORMATS}.
   * 
   * @param format
   *            file format
   */
  public void setFileFormat(String format) {
    this.format = format;
  }

  /**
   * Sets the new frame rate. This value is only used by
   * {@link #getTimeCode()} and has no impact on the export.
   * 
   * @param fps
   *            the fps to set
   */
  public void setFPS(int fps) {
    this.fps = fps;
  }

  /**
   * Sets the number of digits to be used for formatting frame IDs in the
   * filename. Defaults to 5 digits, e.g. 00123.
   * 
   * @param num
   */
  public void setSequenceFormat(int num) {
    StringBuilder format = new StringBuilder(num);
    for (int i = 0; i < num; i++) {
      format.append("0");
    }
    frameIDFormat = new DecimalFormat(format.toString());
  }

  /**
   * Indicate the exporter to start saving out frames.
   */
  public void start() {
    isActive = true;
  }

  /**
   * Indicate the exporter to stop exporting frames.
   */
  public void stop() {
    isActive = false;
  }

  /**
   * This method should be called by the main application at the end of each
   * render loop iteration. Depending on the activity status of the exporter,
   * frames are saved or not.
   * 
   * @param g
   *            PGraphics object to retrieve pixels from
   */
  public void update() {
    if (isActive) {
      g.loadPixels();
      String frameID =
        sessionPath + baseName + "-"
        + frameIDFormat.format(sequenceID) + "." + format;
      g.save(frameID);
      sequenceID++;
    }
  }
}

