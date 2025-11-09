[![Release](https://img.shields.io/github/v/release/DantSu/studio)](https://github.com/DantSu/studio/releases)


STUdio - Story Teller Unleashed
===============================

[Instructions en français](README_fr.md)

Create and transfer your own story packs to and from the Lunii\* story teller device.


DISCLAIMER
----------

This software relies on my own reverse engineering research, which is limited to gathering the information necessary to
ensure interoperability with the Lunii\* story teller device, and does not distribute any protected content.

**USE AT YOUR OWN RISK**. Be advised that despite my best efforts to keep this software safe, it comes with
**NO WARRANTY** and may brick your device.

\* Lunii is a registered trademark of Lunii SAS. I am (and this work is) in no way affiliated with Lunii SAS.


USAGE
-----

### Prerequisite

* Java JRE 11+
* On Windows, this application requires the _libusb_ driver to be installed. The easiest way to achieve this is to have
  the official Luniistore\* software installed (but not running).

### Installation

* **Download** [the latest release](https://github.com/DantSu/studio/releases) (alternatively,
you can [build the application](#for-developers)).
* **Unzip** the distribution archive
* **Run the launcher script**: either `studio-linux.sh`, `studio-macos.sh` or `studio-windows.bat` depending on your
platform. You may need to make them executable first.
* If it does not open automatically, **open a browser** and type the url `http://localhost:8080` to load the web UI.

Important: do not run scripts from `web-ui/src/main/scripts` — those files are templates and get filtered during packaging. Always run the scripts from the built distribution (zip or the `target/...-dist` directory).

Note: avoid running the script as superuser/administrator, as this may create permissions issues.

### Configuration

Configuration order is :
1. (if defined) Java System property (ie: `-Dstudio.port=8081` )
2. (if defined) environment variable (ie: `STUDIO_PORT=8081` )
3. default value (inside code)

| Environment variable | Java System property | Default value | Description |
| ------------------------ | -------------------- | ------ | ----------- |
| `STUDIO_HOST`          | `studio.host`          | `localhost`                    | HTTP listen address |
| `STUDIO_PORT`          | `studio.port`          | `8080`                         | HTTP listen port |
| `STUDIO_DB_OFFICIAL`   | `studio.db.official`   | `~/.studio/db/official.json`   | Official json file database  |
| `STUDIO_DB_UNOFFICIAL` | `studio.db.unofficial` | `~/.studio/db/unofficial.json` | Unofficial json file database |
| `STUDIO_LIBRARY`       | `studio.library`       | `~/.studio/library/`           | Library path |
| `STUDIO_TMPDIR`        | `studio.tmpdir`        | `~/.studio/tmp/`               | Temporary path |
| `STUDIO_OPEN_BROWSER`  | `studio.open.browser`  | `true`                         | Auto open browser |
| `STUDIO_DEV_MODE`      | `studio.dev.mode`      | `prod`                         | if `dev`, enable mock mode |
| `STUDIO_MOCK_DEVICE`   | `studio.mock.device`   | `~/.studio/device/`            | Mock device path |

Sample to disable browser launching (with env var) and listen on port 8081 (with system property) :
- On Windows
```
set STUDIO_OPEN_BROWSER=false

java -Dstudio.port=8081 \
 -Dfile.encoding=UTF-8 -Dvertx.disableDnsResolver=true \
 -cp $STUDIO_PATH/${project.build.finalName}.jar:$STUDIO_PATH/lib/*:. \
 io.vertx.core.Launcher run ${vertx.main.verticle}
```

- On Linux / MacOS
```
export STUDIO_OPEN_BROWSER=false

java -Dstudio.port=8081 \
 -Dfile.encoding=UTF-8 -Dvertx.disableDnsResolver=true \
 -cp $STUDIO_PATH/${project.build.finalName}.jar:$STUDIO_PATH/lib/*:. \
 io.vertx.core.Launcher run ${vertx.main.verticle}` |
```

### Using the application

The web UI is made of two screens:

* The pack library, to manage your local library and transfer to / from your device
* The pack editor, to create or edit a story pack

#### Local library and transfer to/from the device

The pack library screen always shows the story packs in your local library. These are the packs located on your computer
(in a per-user `.studio` folder). **Three file formats** may exist in your library:
* `Raw` is the official format understood by the **older devices** (firmware v1.x -- these devices use a low-level USB protocol)
* `FS` is the official format understood by the **newer devices** (firmware v2.x -- these devices are seen as a removable storage)
* `Archive` is an unofficial format, used by STUdio only in the story pack **editor**

**Conversion** of a story pack will happen automatically when a transfer is initiated, or may be triggered manually.
Variations of a given story pack are grouped together in the UI for better readability. **The most recent file**
(highlighted in the UI) gets transferred to the device.

When the device is plugged, **another pane will appear on the left side**, showing the device metadata and story packs.
**Dragging and dropping** a pack from or to the device will initiate the transfer.

#### Pack editor

The pack editor screen shows the current story pack being edited. By default, it shows a sample story pack intended as
a model of correct usage.

A pack is composed of a few metadata and the diagram describing the various steps in the story:

* Stage nodes are used to display an image and/or play a sound
* Action nodes are used to transition from one stage to the next, and to manage the available options

The editor supports several file formats for audio and image assets.

##### Images

Image files may use the following formats (formats marked with asterisks are automatically converted when transferring
to the device) :
* PNG
* JPEG
* BMP (24-bits)

**Image dimensions must be 320x240**. Images may use colors, even though some colors may not render accurately due to
the screen being behind the plastic cover. Bear in mind that the color of the cover may change.

##### Audio

Audio files may use the following formats (formats marked with asterisks are automatically converted when transferring
to the device) :
* MP3
* OGG/Vorbis
* WAVE (signed 16-bits, mono, 32000 Hz)

MP3 and OGG files are expected to be sampled at 44100Hz.

#### Wiki

More information, including an illustrated usage guide courtesy of [@appenzellois](https://github.com/appenzellois),
available [in the project wiki](https://github.com/marian-m12l/studio/wiki/Documentation).


FOR DEVELOPERS
--------------

### Prerequisite

* Java JDK 11+
* Maven 3+

### Running from IntelliJ IDEA

Option A — via Maven (recommended the first time)
- Open the project as a Maven project in IntelliJ and select JDK 11 for the project SDK.
- In the Maven tool window, run the lifecycle goal on the web UI module once to build the frontend resources:
  - web-ui → Lifecycle → package (or run `mvn -DskipTests -pl web-ui -am package` in the terminal)
- Then run the app using the configured exec plugin:
  - web-ui → Plugins → exec → exec:java
  - Optional: add program argument `dev` to enable mock device in dev mode.

Option B — Application run configuration
- Build once as above (package) so that `webroot` is present on the classpath.
- Run/Debug Configurations → Add New → Application:
  - Name: Studio (Dev)
  - Main class: `studio.webui.TestMain`
  - Use classpath of module: `web-ui`
  - VM options: `-Dfile.encoding=UTF-8 -Dvertx.disableDnsResolver=true`
  - Program arguments (optional): `dev` (enables mock device and disables auto-open browser)
  - Working directory: project root or `web-ui`
- Run. Open `http://localhost:8080` if the browser doesn’t auto-open.

Notes
- You can change the port/host via env vars or system properties (see Configuration section above).
- If `exec:java` is used without packaging first, the UI may be missing; run the `package` step once to generate `webroot`.

### Building and exporting a portable package

This produces a self-contained zip that includes the app, dependencies, launch scripts, and a minimal Java runtime.

- Clone: `git clone https://github.com/marian-m12l/studio.git`
- Build portable package (no tests):
  - Without bundled Java (uses system Java at runtime):
    - Linux/macOS: `mvn -DskipTests -q -pl web-ui -am clean package`
    - Windows: `mvn -DskipTests -pl web-ui -am clean package`
  - With bundled Java (self-contained):
    - Linux/macOS: `mvn -DskipTests -q -P portable-runtime -pl web-ui -am clean package`
    - Windows: `mvn -DskipTests -P portable-runtime -pl web-ui -am clean package`

Result
- The **distribution archive** is created at `web-ui/target/studio-web-ui-<version>-dist.zip`.
- A directory distribution is also created at `web-ui/target/studio-web-ui-<version>-dist/`.
- Run from either location:
  - Linux: `./studio-linux.sh`
  - macOS: `./studio-macos.sh`
  - Windows: `studio-windows.bat`
- Scripts auto-use the bundled runtime (`runtime/bin/java`) if present, so no system Java is required when built with `-P portable-runtime`.

Platform note
- The bundled runtime is platform-specific; build on each target OS/architecture you plan to run on.

From IntelliJ (Windows)
- Open the Maven tool window.
- Optional: check the `portable-runtime` profile to bundle Java.
- Expand `web-ui` → Lifecycle → run `package`.
- Find the zip at `web-ui/target/studio-web-ui-<version>-dist.zip`.
- Unzip anywhere and run `studio-windows.bat`.



THIRD-PARTY APPLICATIONS
------------------------

If you liked STUdio, you will also like:
* [mhios (Mes Histoires Interactives Open Stories)](https://github.com/sebbelese/mhios) is an online open library of interactive
stories (courtesy of [@sebbelese](https://github.com/sebbelese))
* [Moiki](https://moiki.fr/) is an online tool to create interactive stories that can be exported for STUdio (courtesy
of [@kaelhem](https://github.com/kaelhem))


LICENSE
-------

This project is licensed under the terms of the **Mozilla Public License 2.0**. The terms of the license are in
the `LICENSE` file.

The `vorbis-java` library, as well as the `VorbisEncoder` class are licensed by the Xiph.org Foundation. The terms of
the license can be found in the `LICENSE.vorbis-java` file.

The `com.jhlabs.image` package is licensed by Jerry Huxtable under the terms of the Apache License 2.0. The terms of
the license can be found in the `LICENSE.jhlabs` file.
