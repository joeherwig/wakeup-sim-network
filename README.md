Tired of manually starting up your networked Flighsim computers?
This small repo is intended to give you a small advice, how to get all networked computers up and running automatically whenever you startup your FSX or Prepar3D Flight simulator.

It works with FSX and all Prepar3D versions including <img src="http://joachim.herwigs.info/img/P3Dv4-tag.png" height="24px">

## Build
No build needed. It's just pure Windows powershell Script and and uses the `WakeUp-Machines.ps1` Script in Version v1.1, (2012) created by Matthijs ten Seldam (Microsoft).

### Installation
Download the zip from https://github.com/joeherwig/wakeup-sim-network/archive/master.zip and extract it to your desired location.

Within the further documentation i refer to `C:\`

Just add to your exe.xml the following snippet:
```
	<Launch.Addon>
		<Name>Startup networked computers via WakeOnLan</Name>
		<Disabled>false</Disabled>
		<Path>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Path>
        <CommandLine>C:\wakeup-sim-network-master\wakeup-machines.ps1 C:\wakeup-sim-network-master\machines.csv</CommandLine>
	</Launch.Addon>
```
if you unziped the zip-file to `C:\`. Don't forget to change the path within the `<CommandLine>` tag if you unzipped the files to an other directory.

### Config
Just add the computers you want to startup to the machines.csv in the extracted folder.

Eg:
```
Name,MacAddress,IpAddress
Glareshield_left,A0DEF169BE02,192.168.0.11
Glareshield_right,AC1708486CA2,192.168.0.12
FCU,FDDEF15D5401,192.168.0.13
```

Of course you should ensure, that all networked computers you want to fire up during the startup process of your FSX or Prepar3D, are WakeOnLan capable and available via network. If you have just a two computer setup you don't need to run them via a router. A crossover cable or auto-crossover-LAN-card suits fine as well.

Take care: If your computers are networked via WiFi, WOL very often doesn't work!
Please refer to your computers manuals.

### Use
Start your Simulator and this small script will try to start all networked computers you attached to the machines.csv.

So there's nothing left to be done than starting your Prepar3D or FSX.

### What else...
Well. Shutting down the systems i'm currently not doing on exiting the simulator, because i want to avoid that inadvertently anything goes wrong. This could happen, if you were still configuring something on the other systems but don't need the sim anymore... So if you want to add this functionality, feel free to fork this repo and send me a pull request.

<img src="https://joeherwig.github.io/EDST-Flightsim-Scenery_Hahnweide-Kirchheim-unter-Teck/images/JOE-Simtech-Logo.svg" width="100px">
