#!/bin/bash

#*******************************************************************************
# Copyright (c) 2012, 2014 Dr. Philip Wenig.
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
# Replace the placeholder:
# VERSIONPLACEHOLDER => myapp_0.1.0_prev-1
#
#
compilation_amd64='---VERSIONPLACEHOLDER---_amd64'
compilation_i386='---VERSIONPLACEHOLDER---_i386'

sudo rm *.deb
sudo rm *.rpm
sudo chown -R root:root deb/
#
sudo chmod 0644 deb/amd64/$compilation_amd64/DEBIAN/md5sums
sudo chmod 0755 deb/amd64/$compilation_amd64/DEBIAN/postinst
sudo chmod 0755 deb/amd64/$compilation_amd64/DEBIAN/prerm
#
sudo chmod 0644 deb/i386/$compilation_i386/DEBIAN/md5sums
sudo chmod 0755 deb/i386/$compilation_i386/DEBIAN/postinst
sudo chmod 0755 deb/i386/$compilation_i386/DEBIAN/prerm
#
cd deb/amd64/
sudo dpkg -b $compilation_amd64/ $compilation_amd64.deb
sudo alien -r --scripts $compilation_amd64.deb
sudo mv *.deb ../../
sudo mv *.rpm ../../
cd ..
cd i386/
sudo dpkg -b $compilation_i386/ $compilation_i386.deb
sudo alien -r --scripts $compilation_i386.deb
sudo mv *.deb ../../
sudo mv *.rpm ../../
cd ../../

echo "Done - Packaging deb and rpm files as root."
