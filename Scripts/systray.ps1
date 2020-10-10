Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
 
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Start-ShowConsole {
    $PSConsole = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($PSConsole, 5)
}
 
function Start-HideConsole {
    $PSConsole = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($PSConsole, 0)
}

function New-MenuItem{
    param(
        [string]
        $Text = "Placeholder Text",

        $MyScriptPath,
        
        [switch]
        $ExitOnly = $false
    )

    $MenuItem = New-Object System.Windows.Forms.MenuItem

    if($Text){
        $MenuItem.Text = $Text
    }

    if($MyScriptPath -and !$ExitOnly){
        $MenuItem | Add-Member -Name MyScriptPath -Value $MyScriptPath -MemberType NoteProperty
        $MenuItem.Add_Click({
            try{
                $MyScriptPath = $This.MyScriptPath
                
                if(Test-Path $MyScriptPath){
                    Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-NoProfile -NoLogo -ExecutionPolicy Bypass -File `"$MyScriptPath`"" -ErrorAction Stop
                } else {
                    throw "Could not find at path: $MyScriptPath"
                }
            } catch {
                $Text = $This.Text
                [System.Windows.Forms.MessageBox]::Show("Failed to launch $Text`n`n$_") > $null
            }
        })
    }

    if($ExitOnly -and !$MyScriptPath){
        $MenuItem.Add_Click({
            $Form.Close()

            Stop-Process $PID
        })
    }

    $MenuItem
}

$Form = New-Object System.Windows.Forms.Form

$Form.BackColor = "Magenta"
$Form.TransparencyKey = "Magenta"
$Form.ShowInTaskbar = $false
$Form.FormBorderStyle = "None"

$SystrayLauncher = New-Object System.Windows.Forms.NotifyIcon
$SystrayIcon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\scripts\speed.ico")
$SystrayLauncher.Icon = $SystrayIcon
$SystrayLauncher.Text = "CPU Mode"
$SystrayLauncher.Visible = $true

$ContextMenu = New-Object System.Windows.Forms.ContextMenu
$Agressive = New-MenuItem -Text "Agressive" -MyScriptPath "C:\scripts\Agressive.ps1"
$Efficent = New-MenuItem -Text "Efficent" -MyScriptPath "C:\scripts\Efficent.ps1"
$ExitLauncher = New-MenuItem -Text "Exit" -ExitOnly

$ContextMenu.MenuItems.AddRange($Agressive)
$ContextMenu.MenuItems.AddRange($Efficent)
$ContextMenu.MenuItems.AddRange($ExitLauncher)

$SystrayLauncher.ContextMenu = $ContextMenu

Start-HideConsole
$Form.ShowDialog() > $null
Start-ShowConsole