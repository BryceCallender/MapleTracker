; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Maple Tracker"
#define MyAppVersion "1.0.2"
#define MyAppPublisher "Bryce Callender"
#define MyAppExeName "maple_daily_tracker.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{9206E98F-A8D7-4A56-B063-E83CF04912C9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\bryce\Desktop\FlutterMapleTracker\installers
OutputBaseFilename=maple_tracker
SetupIconFile=D:\Users\bryce\Downloads\logo.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\app_links_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\flutter_window_close_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\menubar_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\uni_links_desktop_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\bryce\Desktop\FlutterMapleTracker\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

