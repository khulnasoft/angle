#!/bin/bash

ARCHIVE_VERSION=$1
PACKAGE_VERSION=$2

echo "Copying ZIP archive..."

echo "Preparing LICENSE.rtf.."
cat <<EOF > LICENSE.rtf
{\rtf1\ansi\ansicpg1252\deff0\nouicompat{\fonttbl{\f0\fnil\fcharset0 Lucida Console;}}
\viewkind4\uc1
\pard\f0\fs14\lang1033\par
EOF
sed 's/$/\\/' < angle-"${ARCHIVE_VERSION}"-x86_64-pc-windows-msvc/LICENSE.txt >> LICENSE.rtf
echo -e '\n}' >> LICENSE.rtf

echo "Substituting version..."
VERSION="${PACKAGE_VERSION}" envsubst < angle.wxs.tmpl > angle.wxs

echo "Building the MSI package..."
heat dir angle-"${ARCHIVE_VERSION}"-x86_64-pc-windows-msvc \
  -cg Angle \
  -dr INSTALLDIR \
  -gg \
  -sfrag \
  -srd \
  -var var.AngleDir \
  -out components.wxs
# See https://stackoverflow.com/questions/22932942/wix-heat-exe-win64-components-win64-yes
sed -i'' 's/Component /Component Win64="yes" /g' components.wxs
candle components.wxs -dAngleDir=angle-"${ARCHIVE_VERSION}"-x86_64-pc-windows-msvc
candle angle.wxs -ext WiXUtilExtension
light angle.wixobj components.wixobj -out angle.msi -ext WixUIExtension -ext WiXUtilExtension
