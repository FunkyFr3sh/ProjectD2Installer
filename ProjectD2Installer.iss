;Made with Inno Setup 5.5.9 Ansi - https://files.jrsoftware.org/is/5/innosetup-5.5.9.exe
#include <.\ISTheme\ISTheme.iss>

#define ProjectDiablo2RegisterUrl = "https://www.projectdiablo2.com/register"

[CustomMessages]
GameNotFound=Game files not found in %1 %n%nPlease select a valid Diablo II: Lord of Destruction folder.%n%n%nNote: Project Diablo 2 is a mod for Diablo II: LoD, you must have Diablo II: LoD installed before you can install Project Diablo 2.%n%nIf you don't own Diablo II: LoD yet, you can buy a copy of the game here: https://shop.battle.net/ (Download the English version).
LodNotFound=Diablo II was found in the selected folder but you are missing the Lord of Destruction expansion.%n%nPlease install the Lord of Destruction expansion and then retry.
InstallingApp=Installing %1, this may take several minutes...
EnglishInstallRequired=Project Diablo 2 requires a -English- game installation of Diablo II: Lord of Destruction, please do not try to install it on any other game language or the game will crash randomly.
SelectDiablo2Folder=Please select a valid (English) Diablo II: Lord of Destruction folder.
WantToRegisterAccount=You must create an in-game account on the Project Diablo 2 website to be able to play online games.%n%nWould you like to visit the website now?
CheckFile=d2exp.mpq
CheckFileClassic=d2data.mpq
GameRegEng=SOFTWARE\Blizzard Entertainment\Diablo II

[Setup]
AppId={{822B3055-5F16-4934-A1FC-378AB0181A66}
AppName=Project Diablo 2
AppVersion=1.0
AppVerName=Project Diablo 2
AppPublisher=projectdiablo2.com
VersionInfoVersion=1.0.0.0
VersionInfoTextVersion=1.0.0.0
VersionInfoProductName=Project Diablo 2
VersionInfoDescription=Project Diablo 2
AppPublisherURL=https://www.projectdiablo2.com/
AppSupportURL=https://www.projectdiablo2.com/
AppUpdatesURL=https://www.projectdiablo2.com/
DirExistsWarning=no
DefaultDirName={code:DefaultDir}
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableWelcomePage=yes
DisableFinishedPage=yes
AllowNoIcons=yes
OutputBaseFilename=ProjectD2Installer
Compression=lzma2/max
SolidCompression=no
UsePreviouslanguage=no
CreateUninstallRegKey=yes
UsePreviousAppDir=no
SourceDir=.
OutputDir=.
SetupIconFile=Resources\PD2_Icon.ico
AppendDefaultDirName=no
ShowLanguageDialog=no
RestartIfNeededByRun=no
UninstallFilesDir={app}\ProjectD2

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[InstallDelete]
Type: files; Name: "{app}\ProjectD2\UI.ini"
Type: files; Name: "{app}\ProjectD2\ddraw.ini"
Type: files; Name: "{app}\ProjectD2\D2HD.ini"
Type: files; Name: "{app}\ProjectD2\ProjectDiablo.cfg"
Type: files; Name: "{app}\ProjectD2\bncache.dat"
Type: files; Name: "{app}\ProjectD2\BnetLog.txt"
Type: files; Name: "{app}\ProjectD2\settings.db"

[Files]
Source: Files\*; DestDir: "{app}\ProjectD2"; Flags: ignoreversion
Source: Files\MpqFixer\*; DestDir: "{app}\ProjectD2\MpqFixer"; Flags: ignoreversion

Source: Resources\VC_redist.x86.exe; Flags: dontcopy
Source: Resources\VC_redist.x64.exe; Flags: dontcopy

[Icons]
Name: "{commondesktop}\Project Diablo 2"; Filename: "{app}\ProjectD2\PD2Launcher.exe"; WorkingDir: "{app}\ProjectD2"; Check: not RunsOnWine
Name: "{group}\Project Diablo 2"; Filename: "{app}\ProjectD2\PD2Launcher.exe"; WorkingDir: "{app}\ProjectD2"; Check: RunsOnWine
Name: "{app}\ProjectD2\Uninstall Project Diablo 2"; Filename: "{uninstallexe}"; WorkingDir: "{app}\ProjectD2"

[Run]
Filename: "{tmp}\VC_redist.x86.exe"; Parameters: "/install /passive /norestart"; Flags: runascurrentuser; Check: FileExists(ExpandConstant('{tmp}\VC_redist.x86.exe')) and ChangeStatusLabel('Visual C++ Redistributable 2019 (x86)')

Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /passive /norestart"; Flags: runascurrentuser; Check: FileExists(ExpandConstant('{tmp}\VC_redist.x64.exe')) and ChangeStatusLabel('Visual C++ Redistributable 2019 (x64)')

Filename: "{app}\ProjectD2\MpqFixer\FIX_MPQS_RUN_AS_ADMIN.bat"; WorkingDir: "{app}\ProjectD2\MpqFixer"; Flags: runascurrentuser; Check: ChangeStatusLabel('MPQFixer')

Filename: "{app}\ProjectD2\PD2Launcher.exe"; WorkingDir: "{app}\ProjectD2"; Description: "{cm:LaunchProgram,Project Diablo 2}"; Flags: nowait postinstall runascurrentuser skipifsilent; Check: not OpenRegisterAccountUrl

[UninstallDelete]
Type: filesandordirs; Name: "{app}\ProjectD2"


[Registry]
Root: HKLM; Subkey: Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers; ValueType: String; ValueName: {app}\ProjectD2\PD2Launcher.exe; ValueData: "RUNASADMIN"; Check: not IsWin64

Root: HKLM64; Subkey: Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers; ValueType: String; ValueName: {app}\ProjectD2\PD2Launcher.exe; ValueData: "RUNASADMIN"; Check: IsWin64

Root: HKCU; Subkey: Software\Wine\AppDefaults\game.exe\DllOverrides; ValueType: string; ValueName: "ddraw"; ValueData: "native, builtin"; Check: RunsOnWine

Root: HKCU; Subkey: Software\Blizzard Entertainment\Diablo II; ValueType: string; ValueName: "InstallPath"; ValueData: {app}

[Code]
function GetModuleHandleA(lpLibFileName: PAnsiChar): THandle;
  external 'GetModuleHandleA@kernel32.dll stdcall';

function GetProcAddress(Module: THandle; ProcName: PAnsiChar): Longword;
  external 'GetProcAddress@kernel32.dll stdcall';

function RunsOnWine(): boolean;
begin
  Result := GetProcAddress(GetModuleHandleA('ntdll.dll'), 'wine_get_version')<> 0;
end;

function DefaultDir(Param: String): String;
var
  gamepath: String;
begin
  gamepath:=RemoveBackslashUnlessRoot(ExpandConstant('{reg:HKCU\{cm:GameRegEng},InstallPath|{pf}\Diablo II}'));

  if (not FileExists(gamepath+ExpandConstant('\{cm:CheckFile}'))) then
    gamepath:=RemoveBackslashUnlessRoot(ExtractFilePath(gamepath));
  
  if (not FileExists(gamepath+ExpandConstant('\{cm:CheckFile}'))) then
    gamepath:=ExpandConstant('{pf}\Diablo II');

  Result := gamepath;
end;

function NextButtonClick(CurPage: Integer): Boolean;
var
  ErrorCode: Integer;
begin
  if (CurPage = wpSelectDir) then
  begin
    if (not FileExists(ExpandConstant('{app}\{cm:CheckFile}'))) then
    begin

      if (FileExists(ExpandConstant('{app}\{cm:CheckFileClassic}'))) then
      begin
        MsgBox(ExpandConstant('{cm:LodNotFound}'), mbError, MB_OK);
      end
      else
      begin
        MsgBox(FmtMessage(ExpandConstant('{cm:GameNotFound}'), [WizardForm.DirEdit.Text]), mbError, MB_OK);
      end

      Result := false;
    end
    else Result := true;
  end
  else Result := true;
end;

function OpenRegisterAccountUrl(): Boolean;
var
  ErrorCode: Integer;
begin
  Result := false;

  if MsgBox(ExpandConstant('{cm:WantToRegisterAccount}'), mbConfirmation, MB_YESNO) = IDYES then
  begin
    ShellExecAsOriginalUser('open', '{#ProjectDiablo2RegisterUrl}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
    Result:=true;
  end
end;

function ChangeStatusLabel(AppName: String): Boolean;
begin
  WizardForm.FilenameLabel.Caption := FmtMessage(ExpandConstant('{cm:InstallingApp}'), [AppName]);
  Result := true;
end;

procedure InitializeWizard();
begin
  WizardForm.SelectDirBrowseLabel.Visible := false;
  WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:SelectDiablo2Folder}');
  ISTheme();
end;

procedure CurPageChanged(CurPageID: Integer);
  begin
  if (CurPageID = wpSelectDir) then
  begin
    WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall);
    WizardForm.BackButton.Visible := false;
  end;
end;

function InitializeSetup(): Boolean;
begin
  Result := true;
  ExtractTemporaryFile('VC_redist.x86.exe');
  ExtractTemporaryFile('VC_redist.x64.exe');
end;
