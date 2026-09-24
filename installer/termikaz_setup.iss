; Script Inno Setup 7 para TermiKAZ 🦅
#define MyAppName "TermiKAZ"
#define MyAppVersion "1.1.0"
#define MyAppPublisher "Armando Soares & Kaz Community"
#define MyAppURL "https://github.com/armandosds/Kaz"
#define MyAppExeName "termikaz.exe"

[Setup]
AppId={{C87EBB01-196E-40E8-ABD0-D1C8B98A4E0F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=..\dist
OutputBaseFilename=TermiKAZ_Setup_v{#MyAppVersion}
SetupIconFile=..\assets\flux.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ChangesEnvironment=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "addtopath"; Description: "Adicionar TermiKAZ ao PATH do sistema (permite rodar 'termikaz' em qualquer terminal)"; GroupDescription: "Configurações do Sistema:"
Name: "contextmenu"; Description: "Adicionar 'Abrir TermiKAZ Aqui' no menu de contexto do Windows Explorer"; GroupDescription: "Integração com o Windows Explorer:"

[Files]
Source: "..\target\release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion isreadme
Source: "..\assets\*"; DestDir: "{app}\assets"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName} (Shell POSIX)"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\assets\flux.ico"
Name: "{group}\{#MyAppName} (Emulador GUI)"; Filename: "{app}\{#MyAppExeName}"; Parameters: "--gui"; IconFilename: "{app}\assets\flux.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\assets\flux.ico"; Tasks: desktopicon

[Registry]
; Context menu para pastas
Root: HKCU; Subkey: "Software\Classes\Directory\shell\TermiKAZ"; ValueType: string; ValueName: ""; ValueData: "Abrir TermiKAZ Aqui"; Flags: uninsdeletekey; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\Directory\shell\TermiKAZ"; ValueType: string; ValueName: "Icon"; ValueData: """{app}\assets\flux.ico"""; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\Directory\shell\TermiKAZ\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"""; Tasks: contextmenu

; Context menu para fundo de pastas (Background)
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\TermiKAZ"; ValueType: string; ValueName: ""; ValueData: "Abrir TermiKAZ Aqui"; Flags: uninsdeletekey; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\TermiKAZ"; ValueType: string; ValueName: "Icon"; ValueData: """{app}\assets\flux.ico"""; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\TermiKAZ\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"""; Tasks: contextmenu

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
const
  EnvironmentKey = 'Environment';

procedure AddToPath();
var
  OldPath, NewPath, AppDir: string;
begin
  AppDir := ExpandConstant('{app}');
  if RegQueryStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', OldPath) then
  begin
    if Pos(Uppercase(AppDir), Uppercase(OldPath)) = 0 then
    begin
      if (OldPath <> '') and (OldPath[Length(OldPath)] <> ';') then
        OldPath := OldPath + ';';
      NewPath := OldPath + AppDir;
      RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', NewPath);
    end;
  end
  else
  begin
    RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', AppDir);
  end;
end;

procedure RemoveFromPath();
var
  OldPath: string;
  P: Integer;
  AppDir: string;
begin
  AppDir := ExpandConstant('{app}');
  if RegQueryStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', OldPath) then
  begin
    P := Pos(Uppercase(AppDir) + ';', Uppercase(OldPath));
    if P > 0 then
    begin
      Delete(OldPath, P, Length(AppDir) + 1);
      RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', OldPath);
    end
    else
    begin
      P := Pos(Uppercase(AppDir), Uppercase(OldPath));
      if P > 0 then
      begin
        Delete(OldPath, P, Length(AppDir));
        RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', OldPath);
      end;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('addtopath') then
      AddToPath();
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    RemoveFromPath();
  end;
end;
