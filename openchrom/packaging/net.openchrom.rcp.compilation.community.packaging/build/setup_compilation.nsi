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
#*******************************************************************************

#
# COMPRESSION
# USE lzma, otherwise Windows will throw an error when the script was compiled under linux.
#
SetCompressor lzma

#
# PARAMETERS WILL BE PASSED BY makensis:
# makensis -DARCHITECTURE=x64 -DSOFTWARE_VERSION=0.1.0_prev -DPACKAGE_NAME=OpenChrom -DPACKAGE_NAME_LC=openchrom setup_compilation.nsi
#
!if ${ARCHITECTURE} == x64
  !define PROCESSOR_TYPE "x86_64"
!else
  !define PROCESSOR_TYPE "x86"
!endif

#
# Company
#
!define COMPANY_NAME "Lablicate UG (haftungsbeschränkt)"
!define COMPANY_URL "http://www.lablicate.com"

#
# GENERAL SYMBOL DEFINITIONS
#
Name ${PACKAGE_NAME}
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION ${SOFTWARE_VERSION}
!define COMPANY "${COMPANY_NAME}"
!define URL "${COMPANY_URL}"

#
# SOURCE CODE, PROCESSOR DEFINITIONS
#
!define SOURCE_CODE "win32.win32.${PROCESSOR_TYPE}\${PACKAGE_NAME}"

#
# MULTIUSER SYMBOL DEFINITIONS
#
!define MULTIUSER_MUI
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR "${PACKAGE_NAME}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"

#
# MUI SYMBOL DEFINITIONS
#
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

#
# MUI SETTINGS / HEADER
#
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "NSIS\Graphics\Header\${PACKAGE_NAME_LC}-r-nsis.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "NSIS\Graphics\Header\${PACKAGE_NAME_LC}-uninstall-r-nsis.bmp"

#
# MUI SETTINGS / WIZARD
#
!define MUI_WELCOMEFINISHPAGE_BITMAP "NSIS\Graphics\Wizard\${PACKAGE_NAME_LC}-nsis.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "NSIS\Graphics\Wizard\${PACKAGE_NAME_LC}-uninstall-nsis.bmp"
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PACKAGE_NAME}"
!define MUI_FINISHPAGE_RUN $INSTDIR\${PACKAGE_NAME}.exe
!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\README.txt

#
#--------------------------------------------------------------INCLUDES
#

#
# MODERN INTERFACE
#
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh

#
# PROFILES
#
!include "NTProfiles.nsh"

#
# RESERVED FILES
#
ReserveFile "${NSISDIR}\Plugins\AdvSplash.dll"

#
#--------------------------------------------------------------VARIABLES
#

Var StartMenuGroup

#
#--------------------------------------------------------------PAGES
#

#
# WELCOME AND LICENSE
# JRE DETECTION PAGE
# INSTALLMODE ...
#
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${SOURCE_CODE}\LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
#
# The Multiuser page doesn't use the
# selected installation directory.
# Hence, it will be not used.
#
#!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

#
# INSTALLER LANGUAGES
#
!insertmacro MUI_LANGUAGE English
!insertmacro MUI_LANGUAGE German

#
#--------------------------------------------------------------INCLUDES
#

#
# INSTALLER VALUES
#
OutFile ${PACKAGE_NAME_LC}_${VERSION}_${PROCESSOR_TYPE}_win-setup.exe
InstallDir $INSTDIR
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.2.0.0
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName "${PACKAGE_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription ""
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright "${COMPANY_NAME}"
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

#
#--------------------------------------------------------------INSTALL SECTIONS
#

#
# SEC0000
#
Section -XCompilation SEC0000
    #
    # SET THE INSTALL PATH
    #
    SetOutPath $INSTDIR
    SetOverwrite on
    File "${SOURCE_CODE}\LICENSE.txt"
      
    #
    # INSTALL APPLICATION FILES
    #
    SetOutPath $INSTDIR\jre
    File /r "${SOURCE_CODE}\jre\*"

    SetOutPath $INSTDIR\configuration
    File /r "${SOURCE_CODE}\configuration\*"

    SetOutPath $INSTDIR\features
    File /r "${SOURCE_CODE}\features\*"

    SetOutPath $INSTDIR\p2
    File /r "${SOURCE_CODE}\p2\*"
    
    SetOutPath $INSTDIR\plugins
    File /r "${SOURCE_CODE}\plugins\*"

    #SetOutPath $INSTDIR\readme
    #File /r "${SOURCE_CODE}\readme\*"

    SetOutPath $INSTDIR
    File "${SOURCE_CODE}\artifacts.xml"
    File "${SOURCE_CODE}\${PACKAGE_NAME_LC}.exe"
    File "${SOURCE_CODE}\${PACKAGE_NAME_LC}.ini"
    File "${SOURCE_CODE}\keystore"
    File "${SOURCE_CODE}\CHANGELOG.txt"
    File "${SOURCE_CODE}\README.txt"
    File "${SOURCE_CODE}\LICENSE.txt"
    File "${SOURCE_CODE}\INFO-TRADEMARK.txt"
    File "${SOURCE_CODE}\DemoChromatogram.ocb"

    WriteRegStr HKLM "${REGKEY}\Components" ${PACKAGE_NAME} 1
SectionEnd

#
# SEC0001
#
Section -post SEC0001
    #
    # GET THE INSTALL PATH
    #
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    #
    # MENU/PROGRAM ICONS
    #
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    SetOutPath $INSTDIR
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk" "$INSTDIR\uninstall.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuGroup\${PACKAGE_NAME}.lnk" "$INSTDIR\${PACKAGE_NAME_LC}.exe"
    CreateShortCut "$DESKTOP\${PACKAGE_NAME}.lnk" "$INSTDIR\${PACKAGE_NAME_LC}.exe"
    CreateShortCut "$QUICKLAUNCH\${PACKAGE_NAME}.lnk" "$INSTDIR\${PACKAGE_NAME_LC}.exe"

    #
    # REGISTRY 
    #
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

#
#--------------------------------------------------------------UNINSTALL SECTIONS
#

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}

    next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"

    done${UNSECTION_ID}:
    Pop $R0
!macroend

#
# UNSEC0000
#
Section /o -un.XCompilation UNSEC0000
    Delete /REBOOTOK $INSTDIR\README.txt
    DeleteRegValue HKLM "${REGKEY}\Components" ${PACKAGE_NAME}
SectionEnd

#
# UNSEC0001
#
Section -un.post UNSEC0001
    #
    # DELETE REGISTRY ENTRIES
    #
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
     
    #
    # DELETE FILES
    #
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^UninstallLink).lnk"
    Delete /REBOOTOK "$DESKTOP\${PACKAGE_NAME}.lnk"
    Delete /REBOOTOK "$QUICKLAUNCH\${PACKAGE_NAME}.lnk"

    Delete /REBOOTOK "$INSTDIR\uninstall.exe"
    Delete /REBOOTOK "$INSTDIR\${PACKAGE_NAME_LC}.exe"
    Delete /REBOOTOK "$INSTDIR\${PACKAGE_NAME_LC}.ini"
    Delete /REBOOTOK "$INSTDIR\artifacts.xml"
    Delete /REBOOTOK "$INSTDIR\keystore"
    Delete /REBOOTOK "$INSTDIR\CHANGELOG.txt"
    Delete /REBOOTOK "$INSTDIR\README.txt"
    Delete /REBOOTOK "$INSTDIR\LICENSE.txt"
    Delete /REBOOTOK "$INSTDIR\INFO-TRADEMARK.txt"
    Delete /REBOOTOK "$INSTDIR\DemoChromatogram.ocb" 

    #
    # DELETE DIRS
    #
    RMDir /R /REBOOTOK "$SMPROGRAMS\$StartMenuGroup"

    #
    # RMDir /REBOOTOK $INSTDIR (DELETE IF NOT EMPTY => WITHOUT /R)
    #
    RMDir /R /REBOOTOK "$INSTDIR\jre"
    RMDir /R /REBOOTOK "$INSTDIR\configuration"
    RMDir /R /REBOOTOK "$INSTDIR\features"
    RMDir /R /REBOOTOK "$INSTDIR\p2"
    RMDir /R /REBOOTOK "$INSTDIR\plugins"
    RMDir /R /REBOOTOK "$INSTDIR\readme"

    RMDir /REBOOTOK "$INSTDIR"

    #
    # DELETE USER FILES
    #
    ${EnumProfilePaths} un.DeleteUserProfiles

    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
    
    no_smgroup:
    Pop $R0
SectionEnd

#
#--------------------------------------------------------------FUNCTIONS
#

#
# DELETE USER SPECIFIC FILES
#
Function un.DeleteUserProfiles
    # GET THE NEXT PROFILE PATH
    Pop $0
 
    # REMOVE SPECIFIC FILES
    RMDir /R /REBOOTOK "$0\.${PACKAGE_NAME_LC}" 
    #
    # DON'T REMOVE THE WORKSPACE DATA
    #
    #RMDir /R /REBOOTOK "$0\${PACKAGE_NAME}"

    # CONTINUE
    Push ""
    Return
 
    # STOP ENUMERATION
    # ALL EXCEPT AN EMPTY STRING WILL ABORT THE ENUMERATION
    #Stop:
    #Push "~"
FunctionEnd

#
# INSTALLER
#
Function .onInit
    #
    # SET THE CORRECT REGISTRY ACCESS
    #
    !if ${ARCHITECTURE} == x64
      SetRegView 64
    !else
      SetRegView 32
    !endif
    #
    # INSTALL
    #
    InitPluginsDir
    !insertmacro MULTIUSER_INIT
    !if ${ARCHITECTURE} == x64
      StrCpy $INSTDIR $PROGRAMFILES64\${PACKAGE_NAME}
    !else
      StrCpy $INSTDIR $PROGRAMFILES\${PACKAGE_NAME}
    !endif
FunctionEnd

#
# UNINSTALLER
#
Function un.onInit
    #
    # SET THE CORRECT REGISTRY ACCESS
    #    
    !if ${ARCHITECTURE} == x64
      SetRegView 64
    !else
      SetRegView 32
    !endif
    #
    # UNINSTALL
    #
    SetAutoClose true
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION ${PACKAGE_NAME} ${UNSEC0000}
FunctionEnd

#
# LANGUAGE STRINGS
#
LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_GERMAN} "Uninstall $(^Name)"