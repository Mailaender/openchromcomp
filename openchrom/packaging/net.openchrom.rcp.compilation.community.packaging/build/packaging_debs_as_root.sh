#!/bin/bash

#*******************************************************************************
# Copyright (c) 2012, 2015 Dr. Philip Wenig.
#
# All rights reserved.
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Dr. Philip Wenig - initial API and implementation
#*******************************************************************************

#
# Package name
#
package_name=$1
if [ -z $package_name ]; then
  echo "The package name is not available (OpenChrom)."
  exit
fi

# Lower case package name
package_name_lc=${package_name,,}

#
# Identifier
#
identifier=$2
if [ -z $identifier ]; then
  echo "There is no valid compilation version available (e.g.: 0.9.0_prev)."
  exit
fi

version=$identifier
package_version=$identifier'-1'
v_i386=$package_name_lc'_'$package_version'_i386'
v_amd64=$package_name_lc'_'$package_version'_amd64'

echo "-----------------------------------"
echo "Build the deb packages"
echo "-----------------------------------"

sudo rm *.deb
sudo rm *.rpm
sudo chown -R root:root deb/
#
sudo chmod 0644 deb/i386/$v_i386/DEBIAN/md5sums
sudo chmod 0755 deb/i386/$v_i386/DEBIAN/postinst
sudo chmod 0755 deb/i386/$v_i386/DEBIAN/prerm
#
sudo chmod 0644 deb/amd64/$v_amd64/DEBIAN/md5sums
sudo chmod 0755 deb/amd64/$v_amd64/DEBIAN/postinst
sudo chmod 0755 deb/amd64/$v_amd64/DEBIAN/prerm

# Build the deb packages
sudo dpkg -b ./deb/i386/$v_i386/ $v_i386.deb
sudo dpkg -b ./deb/amd64/$v_amd64/ $v_amd64.deb


echo "-----------------------------------"
echo "Build the rpm packages"
echo "-----------------------------------"
#
# Build rpm packages
#
sudo alien -r --scripts $v_i386.deb
sudo alien -r --scripts $v_amd64.deb

echo "Done - Packaging deb and rpm files as root."
