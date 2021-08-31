#!/bin/bash
# Build
if [ $RELEASE = "release" ]; then
  cargo build --target=x86_64-pc-windows-gnu --release
else
  cargo build --target=x86_64-pc-windows-gnu
fi

# Move
FILE=$(ls target/x86_64-pc-windows-gnu/$RELEASE/*.exe | xargs basename)
mkdir -p dist/$RELEASE || true
cp target/x86_64-pc-windows-gnu/$RELEASE/$FILE dist/$RELEASE/
mingw-ldd dist/$RELEASE/$FILE --dll-lookup-dirs /mingw64/bin | grep -o '/mingw64/bin.*$' | xargs cp -t dist/$RELEASE
