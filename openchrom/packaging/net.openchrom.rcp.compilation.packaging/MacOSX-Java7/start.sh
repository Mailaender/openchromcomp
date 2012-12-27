#!/bin/sh

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

#
# INSTALL FIRST JDK: http://code.google.com/p/openjdk-osx-build 
#
export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home
LAUNCHER_JAR=../../../plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar

java -Xms128M -Xmx500M -Dosgi.requiredJavaVersion=1.7 -Dosgi.install.area.readOnly -Dosgi.instance.area=@user.home/OpenChrom/workspace -Dosgi.user.area=@user.home/.openchrom/0.7.0/Settings -Dsun.awt.xembedserver=true -XstartOnFirstThread -Dorg.eclipse.swt.internal.carbon.smallFonts -jar $LAUNCHER_JAR
