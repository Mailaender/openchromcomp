#!/bin/bash

#*******************************************************************************
# Copyright (c) 2012 Philip (eselmeister) Wenig.
#
# All rights reserved.
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Philip (eselmeister) Wenig - initial API and implementation
#*******************************************************************************

path_openchrom='/home/openchrom/www.openchrom.net/Development/OpenChrom/0.8.0/workspace/openchrom/openchrom/'
path_compilation=$path_openchrom'plugins/net.openchrom.rcp.compilation.product'
path_keys=$path_openchrom'plugins/net.openchrom.keystore/keys'
path_packaging=$path_openchrom'packaging/net.openchrom.rcp.compilation.packaging'

./packaging_openchrom.sh $path_compilation $path_keys $path_packaging | tee openchrom_0.8.0.0-PREV.log

echo "Done - Please test and upload files."
