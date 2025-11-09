Portable executable packaging

Goal: produce a self-contained archive you can run later without setting up the dev toolchain (Maven, Node, etc.). The archive includes the app JAR, all dependencies, scripts, and (optionally) a minimal Java runtime.

Build (local JDK/Maven)
- Prereqs: JDK 11+ and Maven installed. Build on the target OS/arch to get a compatible runtime.
- Command (portable without bundling Java):
  - Linux/macOS: `mvn -DskipTests -q -pl web-ui -am package`
  - Windows (PowerShell): `mvn -DskipTests -pl web-ui -am package`
- Command (portable with bundled Java runtime):
  - Linux/macOS: `mvn -DskipTests -q -P portable-runtime -pl web-ui -am package`
  - Windows (PowerShell): `mvn -DskipTests -P portable-runtime -pl web-ui -am package`
- Result: `web-ui/target/studio-web-ui-<version>-dist.zip` contains everything needed to run. If you activated `portable-runtime`, the `runtime/` folder is included in the zip.

Run the packaged app
- Extract the zip on the machine where you want to run it.
- Use the script for your OS from the extracted folder:
  - Linux: `./studio-linux.sh`
  - macOS: `./studio-macos.sh`
  - Windows: `studio-windows.bat`
- The scripts automatically use the bundled Java runtime (`runtime/bin/java`) if present, so no system Java is required.

Notes
- The bundled runtime is platform-specific. Build the zip on each target platform you plan to run on.
- If you prefer a single-file native binary, consider GraalVM native-image. Given this app’s stack (Vert.x, USB libraries), that path typically requires additional configuration for reflection and native libraries, so it’s not provided here.

Optional: build via Docker
- If you don’t want a local JDK/Maven, you can build inside Docker and copy out the zip. Example multi-stage Dockerfile sketch:

  1) Use a Maven+JDK 11 image to run `mvn -DskipTests -pl web-ui -am package` (add `-P portable-runtime` if you want the runtime included).
  2) Copy `web-ui/target/studio-web-ui-*-dist.zip` out of the container.

This avoids installing the dev toolchain locally; you only need Docker.
