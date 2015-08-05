#!/bin/bash -xe

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
# Dr. Janos Binder - Added -xe to know the failure
#*******************************************************************************



#
# Start
#
echo "Compilation - Start"
#
# Settings
# _prev
# _rel
#
package_name='OpenChrom'
identifier='1.1.0_prev'
#
build_folder='Compilation'
path_repository='../../repository'
path_compilation='../../../../net.openchrom.rcp.compilation.community.product'
path_packaging='../../../../../packaging/net.openchrom.rcp.compilation.community.packaging'
#
# Prepare and copy the build files
#
rm -rf $build_folder 
mkdir $build_folder
cp -R $path_packaging/build/* ./$build_folder/
#
cp -R $path_repository ./$build_folder
#
cp $path_compilation/README.txt ./$build_folder/
cp $path_compilation/CHANGELOG.txt ./$build_folder/
cp $path_compilation/LICENSE.txt ./$build_folder/
cp $path_compilation/INFO-TRADEMARK.txt ./$build_folder/
cp $path_compilation/DemoChromatogram.ocb ./$build_folder/
cp $path_compilation/keystore ./$build_folder/
#
# Start the compilation
#
cd ./$build_folder/
chmod a+x packaging.sh
./packaging.sh $package_name $identifier | tee $package_name-build.log
#
# Done
#
echo "Compilation - Done"
