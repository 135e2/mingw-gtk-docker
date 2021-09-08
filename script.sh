#!/bin/bash
# Build
echo "Building"
if [ $RELEASE = "release" ]; then
  cargo build --target=x86_64-pc-windows-gnu --release
else
  cargo build --target=x86_64-pc-windows-gnu
fi
echo "End building"

# Move
echo "Searching DLL"
FILE=$(ls target/x86_64-pc-windows-gnu/$RELEASE/*.exe | xargs basename)
mkdir -p dist/$RELEASE || true
cp target/x86_64-pc-windows-gnu/$RELEASE/$FILE dist/$RELEASE/
mingw-ldd dist/$RELEASE/$FILE --dll-lookup-dirs /mingw64/bin | grep -o '/mingw64/bin.*$' | xargs cp -t dist/$RELEASE
echo "End searching dll"

# Pixbuf loaders
echo "Preparing gdk-pixbuf"
mkdir -p dist/$RELEASE/lib || true
cp -r /mingw64/lib/gdk-pixbuf-2.0 dist/$RELEASE/lib
wine /mingw64/bin/gdk-pixbuf-query-loaders.exe /mingw64/lib/gdk-pixbuf-2.0/2.10.0/loaders/*.dll | sed "s/\/mingw64\///" > dist/$RELEASE/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
echo "End preparing gdk-pixbuf"