cd \\dc01.victim.local\labs\sysmon\
./sysmon64.exe -accepteula -i sysmonconfig.xml
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational
gpupdate /force