#!/bin/bash

#*******************************************************************************
# Copyright (c) 2011, 2013 Dr. Philip Wenig.
#
# All rights reserved.
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Philip (eselmeister) Wenig - initial API and implementation
#*******************************************************************************

#
# Compilation
#
path_compilation=$1
if [ -z $path_compilation ]; then
  echo "No valid path to the compilation (net.openchrom.rcp.compilation.product)."
  exit
fi

#
# Keys
#
path_keys=$2
if [ -z $path_keys ]; then
  echo "No valid path to the keys (net.openchrom.keystore/keys)."
  exit
fi

#
# Packaging
#
path_packaging=$3
if [ -z $path_packaging ]; then
  echo "No valid path to packaging (net.openchrom.rcp.compilation.packaging)."
  exit
fi

#
# Version
#
version=0.8.0-PREV
package_version=0.8.0_prev-1

#
# Copies the Maven/Tycho builds of OpenChrom.
#
function fetchOsPackage {

  package=$1
  #
  # Replaces
  # linux.gtk.x86_64 -> linux/gtk/x86_64
  #
  packageTychoBuild=${package//\./\/}
  echo "-----------------------------------"
  echo $package \($packageTychoBuild\)
  echo "-----------------------------------"
  echo "delete existing files"
  rm -Rf $package	
  echo "prepare to fetch files from: ../"$packageTychoBuild
    mkdir -p $package/OpenChrom
    cp -R ../$packageTychoBuild/* ./$package/OpenChrom
  echo "done"
}

#
# Copies the README, CHANGELOG and LICENSE files and zips the package.
#
function releaseOsPackage {

  package=$1
  fetchOsPackage $package
  echo "-----------------------------------"
  echo $package
  echo "-----------------------------------"

  echo "prepare: " $package
    cp $path_compilation/README.txt ./$package/OpenChrom/
    cp $path_compilation/CHANGELOG.txt ./$package/OpenChrom/
    cp $path_compilation/LICENSE.txt ./$package/OpenChrom/
    cp $path_compilation/bookmarks.xml ./$package/OpenChrom/
    cp $path_compilation/INFO-TRADEMARK.txt ./$package/OpenChrom/
    cp $path_keys/keystore ./$package/OpenChrom/
  echo "zip: " $package
    zip -r 'openchrom_'$package'_'$version'.zip' $package/
  echo "done"
}

#
# Copy NSIS folder and *.nsi files
#
cp $path_packaging'/setup_openchrom_x86.nsi' ./
cp $path_packaging'/setup_openchrom_x64.nsi' ./
cp -R $path_packaging'/NSIS/' ./

#
# Copy *.deb folders and files
#
cp -R $path_packaging'/deb/' ./

#
# SourceForge releases
#
releaseOsPackage linux.gtk.x86
releaseOsPackage linux.gtk.x86_64
releaseOsPackage macosx.cocoa.ppc
releaseOsPackage macosx.cocoa.x86
releaseOsPackage macosx.cocoa.x86_64
releaseOsPackage solaris.gtk.x86
releaseOsPackage win32.win32.x86
releaseOsPackage win32.win32.x86_64
#
# Additional releases on request
#
#releaseOsPackage aix.motif.ppc
#releaseOsPackage hpux.motif.ia64_32
#releaseOsPackage linux.gtk.ppc
#releaseOsPackage linux.motif.x86
#releaseOsPackage macosx.carbon.ppc
#releaseOsPackage macosx.carbon.x86
#releaseOsPackage solaris.gtk.sparc

#
# Repository
#
zip -r repository.zip repository/

#
# Build Windows installer
#
rm openchrom_*.exe
makensis setup_openchrom_x86.nsi
makensis setup_openchrom_x64.nsi

#
# Build deb packages
#
v_i386='openchrom_'$package_version'_i386'
v_amd64='openchrom_'$package_version'_amd64'
v_i386_opt=$v_i386'/opt/OpenChrom/'$version'/'
v_amd64_opt=$v_amd64'/opt/OpenChrom/'$version'/'

# Remove the INFO.txt. It is used by Git only.
rm ./deb/i386/$v_i386_opt'INFO.txt'
rm ./deb/amd64/$v_amd64_opt'INFO.txt'

# Copy the OpenChrom compilation and the start shell script
cp -R ./linux.gtk.x86/OpenChrom/ ./deb/i386/$v_i386_opt
cp -R ./linux.gtk.x86_64/OpenChrom/ ./deb/amd64/$v_amd64_opt
cp ./deb/start.sh ./deb/i386/$v_i386_opt'OpenChrom/'
cp ./deb/start.sh ./deb/amd64/$v_amd64_opt'OpenChrom/'

# Create md5sums
cd deb/i386/$v_i386/
find opt/ usr/ -type f -exec md5sum {} > DEBIAN/md5sums \;
cd ../../../
cd deb/amd64/$v_amd64/
find opt/ usr/ -type f -exec md5sum {} > DEBIAN/md5sums \;
cd ../../../

# Build the deb packages
dpkg -b ./deb/i386/$v_i386/ $v_i386.deb
dpkg -b ./deb/amd64/$v_amd64/ $v_amd64.deb

#
# Build rpm packages
#
alien -r --scripts $v_i386.deb
alien -r --scripts $v_amd64.deb

#
# INFO - deb files need root:root as owner and group
# md5sums - 0644
#
echo "----------------------------------"
echo "PLEASE RE-RUN THE DEB / RPM BUILDING"
echo ""
echo "sudo chown -R root:root deb/"
echo "sudo chmod 0644 deb/.../openchrom.../DEBIAN/md5sums"
echo "sudo chmod 0755 deb/.../openchrom.../DEBIAN/postinst"
echo "sudo chmod 0755 deb/.../openchrom.../DEBIAN/prerm"
echo "sudo dpkg -b ..."
echo "sudo alien -r --scripts ..."
echo ""
echo "Use packaging_debs_as_root.sh"
echo "----------------------------------"

echo "Congratulation: everything is done"
