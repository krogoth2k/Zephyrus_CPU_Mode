# Zephyrus_CPU_Mode

Since most of us are limiting CPU to 3GHz, I have created simple powershell script to lay in the systray and allow easy switching from Agressive CPU to Efficent Agressive. Just in case You need additional 1.2GHz.

Instructions:
1.Download entire "Scripts" folder or just updated files

2.Unzip folder "Scripts" to C:\.

Structure should look like:
C:\Scripts\systray.ps1

To run it on startup:

1. Create a new shortcut

2. As target paste:
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe C:\Scripts\systray.ps1 -ExecutionPolicy Bypass

3. Open "Run" (Win + R) and Type: shell:startup

4. Paste the file into startup folder. From now, app will start with windows



You can also manualy run it from shortcut.

If Your systray icon is hiding, change it in taskbar settings.


UPDATE 1: Cleaned up unused functions. 


If You have idea about additional options or functions I can add them.
