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
# COMPRESSION
# USE lzma, otherwise Windows will throw an error when the script was compiled under linux.
#
SetCompressor lzma

#
# PARAMETERS WILL BE PASSED BY makensis:
# makensis -DARCHITECTURE=x64 setup_openchrom.nsi
#
!if ${ARCHITECTURE} == x64
  !define PROCESSOR_TYPE "x86_64"
  !define JRE_URL "http://www.openchrom.net/main/downloads/JRE/runtime-x86_64.exe"
!else
  !define PROCESSOR_TYPE "x86"
  !define JRE_URL "http://www.openchrom.net/main/downloads/JRE/runtime-x86.exe"
!endif

#
# GENERAL SYMBOL DEFINITIONS
#
Name OpenChrom
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION ${SOFTWARE_VERSION}
!define COMPANY OpenChrom
!define URL http://www.openchrom.net

#
# SOURCE CODE, PROCESSOR DEFINITIONS
#
!define SOURCE_CODE "win32.win32.${PROCESSOR_TYPE}\OpenChrom"

#
# DETECT AND DOWNLOAD AN APPROPRIATE JRE (1.7)
#
!define JRE_VERSION "1.7"

#
# MULTIUSER SYMBOL DEFINITIONS
#
!define MULTIUSER_MUI
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR "OpenChrom"
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
!define MUI_HEADERIMAGE_BITMAP "NSIS\Graphics\Header\openchrom-r-nsis.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "NSIS\Graphics\Header\openchrom-uninstall-r-nsis.bmp"

#
# MUI SETTINGS / WIZARD
#
!define MUI_WELCOMEFINISHPAGE_BITMAP "NSIS\Graphics\Wizard\openchrom-nsis.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "NSIS\Graphics\Wizard\openchrom-uninstall-nsis.bmp"
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "OpenChrom"
!define MUI_FINISHPAGE_RUN $INSTDIR\OpenChrom.exe
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
# JRE DOWNLOAD
#
!include "JREDyna.nsh"

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
!insertmacro CUSTOM_PAGE_JREINFO
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
OutFile openchrom_${VERSION}_${PROCESSOR_TYPE}_win-setup.exe
InstallDir $INSTDIR
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.2.0.0
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName OpenChrom
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription ""
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

#
#--------------------------------------------------------------INSTALL SECTIONS
#

#
# SEC0000
#
Section -OpenChrom SEC0000
    #
    # SET THE INSTALL PATH
    #
    SetOutPath $INSTDIR
    SetOverwrite on
    File "${SOURCE_CODE}\LICENSE.txt"
    
    #
    # INSTALL JRE IF NEEDED
    #
    call DownloadAndInstallJREIfNecessary
    
    #
    # INSTALL OPENCHROM APPLICATION FILES
    #
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
    File "${SOURCE_CODE}\openchrom.exe"
    File "${SOURCE_CODE}\openchrom.ini"
    File "${SOURCE_CODE}\keystore"

    File "${SOURCE_CODE}\bookmarks.xml"
    File "${SOURCE_CODE}\CHANGELOG.txt"
    File "${SOURCE_CODE}\README.txt"
    File "${SOURCE_CODE}\LICENSE.txt"
    File "${SOURCE_CODE}\INFO-TRADEMARK.txt"
    File "${SOURCE_CODE}\DemoChromatogram.ocb"    

    #File "${SOURCE_CODE}\epl-v10.html"
    #File "${SOURCE_CODE}\notice.html"

    WriteRegStr HKLM "${REGKEY}\Components" OpenChrom 1
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
    
    CreateShortCut "$SMPROGRAMS\$StartMenuGroup\OpenChrom.lnk" "$INSTDIR\openchrom.exe"
    CreateShortCut "$DESKTOP\OpenChrom.lnk" "$INSTDIR\openchrom.exe"
    CreateShortCut "$QUICKLAUNCH\OpenChrom.lnk" "$INSTDIR\openchrom.exe"

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
Section /o -un.OpenChrom UNSEC0000
    Delete /REBOOTOK $INSTDIR\README.txt
    DeleteRegValue HKLM "${REGKEY}\Components" OpenChrom
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
    Delete /REBOOTOK "$DESKTOP\OpenChrom.lnk"
    Delete /REBOOTOK "$QUICKLAUNCH\OpenChrom.lnk"

    Delete /REBOOTOK "$INSTDIR\uninstall.exe"
    Delete /REBOOTOK "$INSTDIR\openchrom.exe"
    Delete /REBOOTOK "$INSTDIR\openchrom.ini"
    Delete /REBOOTOK "$INSTDIR\artifacts.xml"
    Delete /REBOOTOK "$INSTDIR\keystore"

    Delete /REBOOTOK "$INSTDIR\bookmarks.xml"
    Delete /REBOOTOK "$INSTDIR\CHANGELOG.txt"
    Delete /REBOOTOK "$INSTDIR\README.txt"
    Delete /REBOOTOK "$INSTDIR\LICENSE.txt"
    Delete /REBOOTOK "$INSTDIR\INFO-TRADEMARK.txt"
    Delete /REBOOTOK "$INSTDIR\DemoChromatogram.ocb"    

    Delete /REBOOTOK "$INSTDIR\*.log"

    Delete /REBOOTOK "$INSTDIR\epl-v10.html"
    Delete /REBOOTOK "$INSTDIR\notice.html"

    #
    # DELETE DIRS
    #
    RMDir /R /REBOOTOK "$SMPROGRAMS\$StartMenuGroup"

    #
    # RMDir /REBOOTOK $INSTDIR (DELETE IF NOT EMPTY => WITHOUT /R)
    #
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
# DELETE USER SPECIFIC OPENCHROM FILES
#
Function un.DeleteUserProfiles
    # GET THE NEXT PROFILE PATH
    Pop $0
 
    # REMOVE OPENCHROM SPECIFIC FILES
    RMDir /R /REBOOTOK "$0\.openchrom" 
    #
    # DON'T REMOVE THE WORKSPACE DATA
    #
    #RMDir /R /REBOOTOK "$0\OpenChrom"

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
      StrCpy $INSTDIR $PROGRAMFILES64
    !else
      StrCpy $INSTDIR $PROGRAMFILES
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
    !insertmacro SELECT_UNSECTION OpenChrom ${UNSEC0000}
FunctionEnd

#
# LANGUAGE STRINGS
#
LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"
LangString ^UninstallLink ${LANG_GERMAN} "Uninstall $(^Name)"
