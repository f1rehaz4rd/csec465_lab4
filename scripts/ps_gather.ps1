
Write-Host "Part A: "
Write-Host "Host name, OS Name, OS Version"
systeminfo.exe | Select-Object -First 4 | Select-Object -Last 3 
Write-Host "Get Host" 
try { import-module ActiveDirectory -ErrorAction Continue } catch { Write-Error -Message "An error has occurred: $_"; return }; try { Get-ADDomain -Current LocalComputer -OnError SilentlyContinue }catch { Write-Error -Message $_ }
Write-Host "Get hotfixes and sort them by date in descending order"
Get-HotFix -ComputerName ([System.Net.Dns]::GetHostName()) | Sort-Object -Property InstalledOn -Descending | Format-Table -AutoSize 


Write-Host "get ip information"
ipconfig.exe /all


Write-Host "Get local users"
Get-LocalUser

Write-Host "Part B: "

Write-Host "See installed components"
Import-Module ServerManager -ErrorAction SilentlyContinue

Get-WindowsOptionalFeature | where installed
Get-InstalledModule -ErrorAction SilentlyContinue
#Get-Service | Sort-Object -Property status | Format-Table -AutoSize -Expand Both
Write-Host "Get installed software"
Get-WmiObject -Class Win32_Product

Write-Host "Runs on startup"

Get-CimInstance -ClassName Win32_StartupCommand | Select-Object -Property Command, Description, User, Location | Format-Table -AutoSize


Write-Host "Part C: "

Write-Host "Recent logged on users within 7 days"
$cur_date = Get-Date -Format "dd"
$seven_days_before = $(Get-Date).AddDays(-7).ToString("dd") 
$users = @()
Get-LocalUser | ForEach-Object { if ($_ -ne $null) { $users += $_.Name } } 

foreach ($user in $users) {
    $tmp = net user $user | findstr /B /C:"Last logon" 
    $tmp = [string]$tmp
    $tmp = $tmp.Replace("?", "")
    $tmp = $($tmp -replace '\s+', ' ').split() -match "/"
    foreach ($k in $tmp) {
        $k = $k.split("/")[1] 
        if ([int]$k -In [int]$seven_days_before..[int]$cur_date) {
            Write-Host "user is: $user and $($(net user $user | findstr /B /C:'Last logon').replace('?',''))"
        }
    }
}

Write-Host "Running Processes"

Get-WmiObject win32_process | Select-Object ProcessName, ProcessID, ParentProcessID, Path | Format-Table -AutoSize

Write-Host "Suspicious Activity that is Established State"

Get-NetTCPConnection | ForEach-Object { if ($_.RemotePort -ne 80 -and $_.RemotePort -ne 443 -and $_.State -eq "Established" -and $_.LocalPort -ne 443 -and $_.LocalAddress -ne 80) { $_ } }


