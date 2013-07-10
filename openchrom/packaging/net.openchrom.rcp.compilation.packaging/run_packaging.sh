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

workspace='/home/openchrom/www.openchrom.net/Development/OpenChrom/0.8.x/workspace/'
path_openchrom=$workspace'openchrom/openchrom/'
path_keys=$path_openchrom'plugins/net.openchrom.keystore/keys'
path_compilation=$workspace'openchromcomp/openchrom/plugins/net.openchrom.rcp.compilation.product'
path_packaging=$workspace'openchromcomp/openchrom/packaging/net.openchrom.rcp.compilation.packaging'
#
# Use Tycho or PDE
#
type_builder='PDE'
#
# Build folder
#
build_folder='Community'

mkdir $build_folder
cp -R $path_packaging/build/* ./$build_folder/
cd ./$build_folder/
./packaging_openchrom.sh $path_compilation $path_keys $path_packaging $type_builder | tee openchrom_0.8.0.0.log

echo "Done - Please test and upload files."
