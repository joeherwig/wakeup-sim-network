param([string]$InstallPath=$PSScriptRoot)
clear

$lang = get-culture
$path  = @(
    New-Object PSObject -Property @{Name = "FSX"; exeXmlPath="$env:APPDATA\Microsoft\FSX"}
    New-Object PSObject -Property @{Name = "Prepar3D V2"; exeXmlPath="$env:APPDATA\Lockheed Martin\Prepar3D V2"}
    New-Object PSObject -Property @{Name = "Prepar3D V3"; exeXmlPath="$env:APPDATA\Microsoft\FSX"}
    New-Object PSObject -Property @{Name = "Prepar3D V4"; exeXmlPath="$env:APPDATA\Microsoft\FSX"}
)

function get-help() {
    write-host
    write-host "We couldn't either find FSX nor Prepar3D on your system. Please add the script-block manually to your exe.xml. "
    write-host "See the README.md or https://github.com/joeherwig/wakeup-sim-network/wiki/"
    $IE=new-object -com internetexplorer.application
    if ($lang.TwoLetterISOLanguageName -eq "de") {
        $notFoundUrl = "https://github.com/joeherwig/wakeup-sim-network/wiki/Deutsch#simulator-nicht-gefunden"
    } else {
        $notFoundUrl = "https://github.com/joeherwig/wakeup-sim-network/wiki/English#simulator-not-found"
    }
    $IE.navigate2($notFoundUrl )
    $IE.visible=$true
}

function write-exeXml($folderPath) {
    write-host "Creating missing exe.xml and Installing into"$path[$i].Name"!"
    $xml = [xml]"<?xml version='1.0' encoding='UTF-8'?>
<SimBase.Document Type='Launch' version='1,0'>
  <Descr>Launch</Descr>
  <Filename>EXE.xml</Filename>
  <Disabled>False</Disabled>
  <Launch.ManualLoad>False</Launch.ManualLoad>
  <Launch.Addon>
    <Disabled>False</Disabled>
    <ManualLoad>False</ManualLoad>
    <Name>Addon Application</Name>
    <Path>C:\MyPath\Addon.exe</Path>
    <NewConsole>True</NewConsole>
  </Launch.Addon>
  <Launch.Addon>
    <Name>Startup networked computers via WakeOnLan</Name>
    <Disabled>False</Disabled>
    <Path>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Path>
    <CommandLine>$InstallPath\wakeup-machines.ps1 $InstallPath\machines.csv</CommandLine>
  </Launch.Addon>
</SimBase.Document>"
    $outFile = (join-path $folderPath "exe.xml" )
    $xml.Save($outFile );
}

function update-exeXml($folderPath) { 
    $xml = [System.Xml.XmlDocument](Get-Content $exeXmlPath);
    if (($xml | select -ExpandProperty childnodes | select -ExpandProperty InnerText) -like "*$InstallPath\wakeup-machines.ps1 $InstallPath\machines.csv*") {
        write-host $path[$i].Name"contains already the script"
    } else {
        Write-Host "Installing into "$path[$i].Name"via "$exeXmlPath
        $newSettings = $xml.CreateElement("Launch.Addon")
        $name = $xml.CreateElement("Name")
        $name.InnerText = "Startup networked computers via WakeOnLan"
        $disabled = $xml.CreateElement("Disabled")
        $disabled.innerText = "False"
        $path = $xml.CreateElement("Path")
        $path.innerText = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $commandLine = $xml.CreateElement("CommandLine")
        $commandLine.innerText = "$InstallPath\wakeup-machines.ps1 $InstallPath\machines.csv"
        $newSettings.AppendChild($name)
        $newSettings.AppendChild($disabled)
        $newSettings.AppendChild($path)
        $newSettings.AppendChild($commandLine)
        $xml['SimBase.Document'].AppendChild($newSettings)
        $outFile = (join-path $folderPath "exe.xml" )
        $xml.Save($outFile );
    }
}

$result = 0
for ($i=0; $i -lt $path.length; $i++){
   $exeXmlPath = join-path $path[$i].exeXmlPath "exe.xml"
   if (Test-Path $path[$i].exeXmlPath) {
        If (Test-Path $exeXmlPath){
            update-exeXml($path[$i].exeXmlPath)
        } else {
            write-exeXml($path[$i].exeXmlPath)
        }
    } else {
        Write-host $path[$i].Name "not found for installation."
        $result++
    }
}

if ($result -eq $path.length) {
    get-help
}
