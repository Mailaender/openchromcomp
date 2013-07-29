#!/bin/bash

#*******************************************************************************
# Copyright (c) 2012, 2013 Dr. Philip Wenig.
#
# All rights reserved.
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Philip (eselmeister) Wenig - initial API and implementation
#*******************************************************************************

openchrom_amd64='openchrom_0.8.0_rel-1_amd64'
openchrom_i386='openchrom_0.8.0_rel-1_i386'

sudo rm *.deb
sudo rm *.rpm
sudo chown -R root:root deb/
#
sudo chmod 0644 deb/amd64/$openchrom_amd64/DEBIAN/md5sums
sudo chmod 0755 deb/amd64/$openchrom_amd64/DEBIAN/postinst
sudo chmod 0755 deb/amd64/$openchrom_amd64/DEBIAN/prerm
#
sudo chmod 0644 deb/i386/$openchrom_i386/DEBIAN/md5sums
sudo chmod 0755 deb/i386/$openchrom_i386/DEBIAN/postinst
sudo chmod 0755 deb/i386/$openchrom_i386/DEBIAN/prerm
#
cd deb/amd64/
sudo dpkg -b $openchrom_amd64/ $openchrom_amd64.deb
sudo alien -r --scripts $openchrom_amd64.deb
sudo mv *.deb ../../
sudo mv *.rpm ../../
cd ..
cd i386/
sudo dpkg -b $openchrom_i386/ $openchrom_i386.deb
sudo alien -r --scripts $openchrom_i386.deb
sudo mv *.deb ../../
sudo mv *.rpm ../../
cd ../../

echo "Done - Packaging deb and rpm files as root."
