#!/bin/bash

#*******************************************************************************
# Copyright (c) 2011, 2016 Dr. Philip Wenig.
#
# All rights reserved.
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Dr. Philip Wenig - initial API and implementation
# Dr. Janos Binder - checking for the available commands
#*******************************************************************************

#
# Checking whether the command are available
# 

isnsis=$(command -v makensis)
isalien=$(command -v alien)
iszip=$(command -v zip)

if [ -z "$isnsis" ] || [ -z "$isalien" ] || [ -z "$iszip" ]; then
  echo "FAIL: Please check, whether nsis, alien or zip are installed."
  exit 1
fi

#
# Package name
#
package_name=$1
if [ -z $package_name ]; then
  echo "The package name is not available (OpenChrom)."
  exit 1
fi

# Lower case package name
package_name_lc=${package_name,,}

#
# Identifier
#
identifier=$2
if [ -z $identifier ]; then
  echo "There is no valid compilation version available (e.g.: 0.9.0_prev)."
  exit 1
fi

version=$identifier
package_version=$identifier'-1'

#
# Copies the Maven/Tycho builds.
#
function fetchOsPackage {

  echo "-----------------------------------"
  echo "Run fetchOSPackage > Maven/Tycho."
  echo "-----------------------------------"
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
    mkdir -p $package/$package_name
    cp -R ../$packageTychoBuild/* ./$package/$package_name
  echo "done"
}

#
# Copies the README, CHANGELOG and LICENSE files and zips the package.
#
function releaseOsPackageZIP {

  package=$1
  echo "-----------------------------------"
  echo $package
  echo "-----------------------------------"

  echo "prepare: " $package
    cp README.txt ./$package/$package_name/
    cp CHANGELOG.txt ./$package/$package_name/
    cp LICENSE.txt ./$package/$package_name/
    cp INFO-TRADEMARK.txt ./$package/$package_name/
    cp DemoChromatogram.ocb ./$package/$package_name/
    cp keystore ./$package/$package_name/
  echo "zip: " $package
    cd $package/'OpenChrom'
    zip -r $package_name_lc'_'$package'_'$version'.zip' .
    mv $package_name_lc'_'$package'_'$version'.zip' ../../
    cd ../../
  echo "done"
}

#
# Copies the README, CHANGELOG and LICENSE files and tar.gz the package.
#
function releaseOsPackageTAR {

  package=$1
  echo "-----------------------------------"
  echo $package
  echo "-----------------------------------"

  echo "prepare: " $package
    cp README.txt ./$package/$package_name/
    cp CHANGELOG.txt ./$package/$package_name/
    cp LICENSE.txt ./$package/$package_name/
    cp INFO-TRADEMARK.txt ./$package/$package_name/
    cp DemoChromatogram.ocb ./$package/$package_name/
    cp keystore ./$package/$package_name/
  echo "tar.gz: " $package
    tar cfvz $package_name_lc'_'$package'_'$version'.tar.gz' $package/
  echo "done"
}

#
# Adds -Dosgi.install.area.readOnly to the .ini file
#
function addInstallAreaReadOnly {

  package=$1
  echo "-----------------------------------"
  echo $package
  echo "-----------------------------------"

  version_x=${version:0:4}"x"
  sed -i '/-Dapplication.version='$version_x'/a -Dosgi.install.area.readOnly' $package/$package_name/$package_name_lc.ini
}

#
# Removes -Dosgi.install.area.readOnly from the .ini file
#
function removeInstallAreaReadOnly {

  package=$1
  echo "-----------------------------------"
  echo $package
  echo "-----------------------------------"

  sed -i '/-Dosgi.install.area.readOnly/d' $package/$package_name/$package_name_lc.ini
}

#
# Fetch the packages
#
fetchOsPackage linux.gtk.x86
fetchOsPackage linux.gtk.x86_64
fetchOsPackage macosx.cocoa.x86_64
fetchOsPackage solaris.gtk.x86
fetchOsPackage win32.win32.x86
fetchOsPackage win32.win32.x86_64

#
# Prepares the JRE for each release except Linux, Solaris.
#
current_jre=$(find ./jre -type f -name 'jre-*.tar.gz')
current_version=$(echo $current_jre | cut -d '-' -f 2)
current_update=$(echo $current_version | cut -d 'u' -f 2)
java_prefix='jre-'$current_version
java_identifer='jre1.8.0_'$current_update
#
tar -xvzf jre/$java_prefix-macosx-x64.tar.gz -C ./macosx.cocoa.x86_64/$package_name/
mv ./macosx.cocoa.x86_64/$package_name/$java_identifer.jre ./macosx.cocoa.x86_64/$package_name/jre
#
tar -xvzf jre/$java_prefix-windows-i586.tar.gz -C ./win32.win32.x86/$package_name/
mv ./win32.win32.x86/$package_name/$java_identifer ./win32.win32.x86/$package_name/jre
#
tar -xvzf jre/$java_prefix-windows-x64.tar.gz -C ./win32.win32.x86_64/$package_name/
mv ./win32.win32.x86_64/$package_name/$java_identifer ./win32.win32.x86_64/$package_name/jre

#
# Release the packages
#
releaseOsPackageTAR linux.gtk.x86
releaseOsPackageTAR linux.gtk.x86_64
releaseOsPackageTAR macosx.cocoa.x86_64
releaseOsPackageZIP solaris.gtk.x86
releaseOsPackageZIP win32.win32.x86
releaseOsPackageZIP win32.win32.x86_64

#
# Repository
#
echo "-----------------------------------"
echo "ZIP the repository"
echo "-----------------------------------"
zip -r repository.zip repository/

#
# Add the install area read only directive
#
echo "-----------------------------------"
echo "Add the read only directive"
echo "-----------------------------------"
addInstallAreaReadOnly linux.gtk.x86
addInstallAreaReadOnly linux.gtk.x86_64
addInstallAreaReadOnly win32.win32.x86
addInstallAreaReadOnly win32.win32.x86_64

#
# Build Windows installer
#
echo "-----------------------------------"
echo "Build the Windows installer"
echo "-----------------------------------"
rm compilation_*.exe
#
mv ./NSIS/Graphics/Header/EXECUTABLEPLACEHOLDER-header.svg ./NSIS/Graphics/Header/$package_name_lc-header.svg
mv ./NSIS/Graphics/Header/EXECUTABLEPLACEHOLDER-r-nsis.bmp ./NSIS/Graphics/Header/$package_name_lc-r-nsis.bmp
mv ./NSIS/Graphics/Header/EXECUTABLEPLACEHOLDER-uninstall-r-nsis.bmp ./NSIS/Graphics/Header/$package_name_lc-uninstall-r-nsis.bmp
mv ./NSIS/Graphics/Wizard/EXECUTABLEPLACEHOLDER-nsis.bmp ./NSIS/Graphics/Wizard/$package_name_lc-nsis.bmp
mv ./NSIS/Graphics/Wizard/EXECUTABLEPLACEHOLDER-uninstall-nsis.bmp ./NSIS/Graphics/Wizard/$package_name_lc-uninstall-nsis.bmp
mv ./NSIS/Graphics/Wizard/EXECUTABLEPLACEHOLDER-wizard.svg ./NSIS/Graphics/Wizard/$package_name_lc-wizard.svg
#
makensis -DARCHITECTURE=x32 -DSOFTWARE_VERSION=$version -DPACKAGE_NAME=$package_name -DPACKAGE_NAME_LC=$package_name_lc setup_compilation.nsi
makensis -DARCHITECTURE=x64 -DSOFTWARE_VERSION=$version -DPACKAGE_NAME=$package_name -DPACKAGE_NAME_LC=$package_name_lc setup_compilation.nsi

echo "-----------------------------------"
echo "Build the deb packages"
echo "-----------------------------------"
#
# Build deb packages
#
# _ underscores are not allowed in the version
deb_version=${version//_/-}
v_i386=$package_name_lc'_'$package_version'_i386'
v_amd64=$package_name_lc'_'$package_version'_amd64'
v_i386_opt=$v_i386'/opt/'$package_name'/'$deb_version
v_amd64_opt=$v_amd64'/opt/'$package_name'/'$deb_version
executable_placeholder=$package_name_lc
version_placeholder=$package_name_lc'_'$deb_version

# Rename the executable placeholder in start.sh
sed -i s/"---EXECUTABLEPLACEHOLDER---"/$executable_placeholder/g ./deb/start.sh

#
# Rename the folders of the skeleton
#
mv ./deb/i386/---VERSIONPLACEHOLDER---/ ./deb/i386/$v_i386/
mv ./deb/amd64/---VERSIONPLACEHOLDER---/ ./deb/amd64/$v_amd64/
#
mv ./deb/i386/$v_i386/opt/---PACKAGENAME--- ./deb/i386/$v_i386/opt/$package_name
mv ./deb/amd64/$v_amd64/opt/---PACKAGENAME--- ./deb/amd64/$v_amd64/opt/$package_name
#
mv ./deb/i386/$v_i386/opt/$package_name/---VERSION--- ./deb/i386/$v_i386/opt/$package_name/$deb_version
mv ./deb/amd64/$v_amd64/opt/$package_name/---VERSION--- ./deb/amd64/$v_amd64/opt/$package_name/$deb_version
#
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/i386/$v_i386/DEBIAN/postinst
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/amd64/$v_amd64/DEBIAN/postinst
sed -i s/"---PACKAGENAME---"/$package_name/g ./deb/i386/$v_i386/DEBIAN/postinst
sed -i s/"---PACKAGENAME---"/$package_name/g ./deb/amd64/$v_amd64/DEBIAN/postinst
sed -i s/"---EXECUTABLEPLACEHOLDER---"/$package_name_lc/g ./deb/i386/$v_i386/DEBIAN/postinst
sed -i s/"---EXECUTABLEPLACEHOLDER---"/$package_name_lc/g ./deb/amd64/$v_amd64/DEBIAN/postinst
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/i386/$v_i386/DEBIAN/control
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/amd64/$v_amd64/DEBIAN/control
sed -i s/"---PACKAGENAME---"/$package_name_lc/g ./deb/i386/$v_i386/DEBIAN/control
sed -i s/"---PACKAGENAME---"/$package_name_lc/g ./deb/amd64/$v_amd64/DEBIAN/control
#
mv ./deb/i386/$v_i386/usr/share/applications/VERSIONPLACEHOLDER.desktop ./deb/i386/$v_i386/usr/share/applications/$version_placeholder.desktop
mv ./deb/amd64/$v_amd64/usr/share/applications/VERSIONPLACEHOLDER.desktop ./deb/amd64/$v_amd64/usr/share/applications/$version_placeholder.desktop
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/i386/$v_i386/usr/share/applications/$version_placeholder.desktop
sed -i s/"---VERSIONPLACEHOLDER---"/$deb_version/g ./deb/amd64/$v_amd64/usr/share/applications/$version_placeholder.desktop
sed -i s/"---EXECUTABLEPLACEHOLDER---"/$package_name_lc/g ./deb/i386/$v_i386/usr/share/applications/$version_placeholder.desktop
sed -i s/"---EXECUTABLEPLACEHOLDER---"/$package_name_lc/g ./deb/amd64/$v_amd64/usr/share/applications/$version_placeholder.desktop
sed -i s/"---PACKAGENAME---"/$package_name/g ./deb/i386/$v_i386/usr/share/applications/$version_placeholder.desktop
sed -i s/"---PACKAGENAME---"/$package_name/g ./deb/amd64/$v_amd64/usr/share/applications/$version_placeholder.desktop
#
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/16x16/apps/EXECUTABLEPLACEHOLDER.png ./deb/i386/$v_i386/usr/share/icons/hicolor/16x16/apps/$package_name_lc.png
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/16x16/apps/EXECUTABLEPLACEHOLDER.png ./deb/amd64/$v_amd64/usr/share/icons/hicolor/16x16/apps/$package_name_lc.png
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/22x22/apps/EXECUTABLEPLACEHOLDER.png ./deb/i386/$v_i386/usr/share/icons/hicolor/22x22/apps/$package_name_lc.png
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/22x22/apps/EXECUTABLEPLACEHOLDER.png ./deb/amd64/$v_amd64/usr/share/icons/hicolor/22x22/apps/$package_name_lc.png
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/24x24/apps/EXECUTABLEPLACEHOLDER.png ./deb/i386/$v_i386/usr/share/icons/hicolor/24x24/apps/$package_name_lc.png
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/24x24/apps/EXECUTABLEPLACEHOLDER.png ./deb/amd64/$v_amd64/usr/share/icons/hicolor/24x24/apps/$package_name_lc.png
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/32x32/apps/EXECUTABLEPLACEHOLDER.png ./deb/i386/$v_i386/usr/share/icons/hicolor/32x32/apps/$package_name_lc.png
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/32x32/apps/EXECUTABLEPLACEHOLDER.png ./deb/amd64/$v_amd64/usr/share/icons/hicolor/32x32/apps/$package_name_lc.png
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/48x48/apps/EXECUTABLEPLACEHOLDER.png ./deb/i386/$v_i386/usr/share/icons/hicolor/48x48/apps/$package_name_lc.png
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/48x48/apps/EXECUTABLEPLACEHOLDER.png ./deb/amd64/$v_amd64/usr/share/icons/hicolor/48x48/apps/$package_name_lc.png
mv ./deb/i386/$v_i386/usr/share/icons/hicolor/scalable/apps/EXECUTABLEPLACEHOLDER.svg ./deb/i386/$v_i386/usr/share/icons/hicolor/scalable/apps/$package_name_lc.svg
mv ./deb/amd64/$v_amd64/usr/share/icons/hicolor/scalable/apps/EXECUTABLEPLACEHOLDER.svg ./deb/amd64/$v_amd64/usr/share/icons/hicolor/scalable/apps/$package_name_lc.svg

# Remove the INFO.txt. It is used by Git only.
rm ./deb/i386/$v_i386_opt'/INFO.txt'
rm ./deb/amd64/$v_amd64_opt'/INFO.txt'

# Set the file permissions.
chmod 0755 ./deb/i386/$v_i386/DEBIAN/postinst
chmod 0755 ./deb/i386/$v_i386/DEBIAN/prerm
chmod 0755 ./deb/amd64/$v_amd64/DEBIAN/postinst
chmod 0755 ./deb/amd64/$v_amd64/DEBIAN/prerm

# Copy the compilation and the start shell script
cp -R ./linux.gtk.x86/$package_name/ ./deb/i386/$v_i386_opt'/'
cp -R ./linux.gtk.x86_64/$package_name/ ./deb/amd64/$v_amd64_opt'/'
cp ./deb/start.sh ./deb/i386/$v_i386_opt'/'$package_name'/'
cp ./deb/start.sh ./deb/amd64/$v_amd64_opt'/'$package_name'/'
chmod a+x ./deb/i386/$v_i386_opt'/'$package_name'/start.sh'
chmod a+x ./deb/amd64/$v_amd64_opt'/'$package_name'/start.sh'

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


echo "-----------------------------------"
echo "Build the rpm packages"
echo "-----------------------------------"
#
# Build rpm packages
#
alien -r --scripts $v_i386.deb
alien -r --scripts $v_amd64.deb

#
# Remove the install area read only directive
#
echo "-----------------------------------"
echo "Remove the read only directive"
echo "-----------------------------------"
removeInstallAreaReadOnly linux.gtk.x86
removeInstallAreaReadOnly linux.gtk.x86_64
removeInstallAreaReadOnly win32.win32.x86
removeInstallAreaReadOnly win32.win32.x86_64

#
# INFO - deb files need root:root as owner and group
# md5sums - 0644
#
echo "----------------------------------"
echo "PLEASE RE-RUN THE DEB / RPM BUILDING AS SUDO"
echo "sudo ./packaging_debs_as_root.sh "$package_name" "$identifier
echo "----------------------------------"

echo "Done"
