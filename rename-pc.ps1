# Written By: Benjamin Stout | 2016-05-13
# Remotely renames and reboots managed computer

$user = whoami

$computer = read-host -prompt 'Computer to rename';

$newname = read-host -prompt 'New computer name';

Write-Host "Pressing enter will rename $computer to $newname..."

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

rename-computer -NewName $newname -ComputerName $computer -DomainCredential $user

$reboot = read-host -prompt 'Reboot computer (prompting user) to force immediate name change? [y/n]';

if($reboot -eq 'y' -or $reboot -eq'Y'){

    Invoke-WmiMethod -Class Win32_Process -ComputerName $computer -Name create -ArgumentList "C:\Windows\System32\msg.exe * Restarting in 1 minute to process a name change. Please save your work."

    $xCmdString = {sleep 60}

    Invoke-Command $xCmdString

    Restart-Computer -ComputerName $computer -Force
}