------------------------------------------------------------------
DecodeIdent: The V&A Decode generative identity
------------------------------------------------------------------

The Victoria & Albert Museum has commissioned Karsten Schmidt
to design a truly malleable, digital identity for the Decode
exhibition by providing it as an open source project.

We are giving you the opportunity to recode Karsten's work and
create your own original artwork. If we love your work it might
even become the new Decode identity. 

------------------------------------------------------------------
Credits:
------------------------------------------------------------------

Copyright 2009 Karsten Schmidt - http://postspectacular.com/

------------------------------------------------------------------
Contact:
------------------------------------------------------------------

http://decode.googlecode.com/ (project website/wiki)
http://www.vam.ac.uk/decode/  (exhibition website)

For source code enquiries please contact:
Karsten Schmidt <info at postspectacular dot com>

For recode submissions please see instructions on the Decode
project website: http://decode.googlecode.com/

------------------------------------------------------------------
License disclaimer:
------------------------------------------------------------------

DecodeIdent is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

DecodeIdent is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with DecodeIdent. If not, see <http://www.gnu.org/licenses/>.

------------------------------------------------------------------
Minimum requirements:
------------------------------------------------------------------

* 1.6GHz dual core CPU
* 150MB free RAM (more required for high resolution asset export)
* Graphics card with pixel shader support
* Java 5 (http://java.sun.com)

------------------------------------------------------------------
Dependencies:
------------------------------------------------------------------

The software bundles the following libraries in binary form
as permitted under the GPL:

* http://processing.org (LGPL: core.jar & opengl.jar)
* http://toxiclibs.org (LGPL: toxiclibscore, colorutils, volumeutils)
* http://sojamo.de/libraries/controlP5/ (LGPL)
* https://jogl.dev.java.net (BSD)

------------------------------------------------------------------
Application launch
------------------------------------------------------------------

Mac OS X: Double click DecodeIdent.app to launch
Windows : Double click on run.bat

------------------------------------------------------------------
Usage:
------------------------------------------------------------------

Please refer to the complete user guide on the project wiki at:
http://decode.googlecode.com

If you're interested in extending & creating your own version of the
software, you can also find development notes on the above site.
 
Key commands:

------------------------------------------------------------------
Mesh
------------------------------------------------------------------

U : turn mesh animation on/off
X : rebuild meshes
L : turn lighting on/off
N : turn updating triangle reflection vectors on/off

------------------------------------------------------------------
Camera
------------------------------------------------------------------

Shift + mouse click/drag to rotate camera
(use camera UI tab to adjust other parameters)

R     : turn auto-rotation on/off
- / + : adjust camera zoom
1 - 9 : trigger camera preset (by default only 5 are defined)

------------------------------------------------------------------
Exporting
------------------------------------------------------------------

T : save current frame as tiled XL output (images stored in /export folder)
SPACE : start/stop recording of image sequence

------------------------------------------------------------------
Misc
------------------------------------------------------------------
H : Help instructions on/off
Escape - quit application (or Command+Q on OSX / Alt+F4 on Windows)
