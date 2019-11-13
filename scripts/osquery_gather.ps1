Write-Host "Part A: "

Write-Host "Get hostname and domain if possible"

osqueryi "SELECT local_hostname, computer_name, local_hostname FROM system_info"


Write-Host "OS Name, OS Version, and patches"
osqueryi "SELECT name, version, major, minor, patch from os_version"

Write-Host "Patch information "

osqueryi "SELECT csname, hotfix_id, caption,description, installed_on FROM patches"

Write-Host "Get ip information gets address & hostnames"
osqueryi "SELECT * from etc_hosts" 

Write-Host "Get Local users and type of user"

osqueryi "SELECT username, type from users"

Write-Host "Part B: "

osqueryi "SELECT name,version from programs" --line

osqueryi "SELECT name,path from autoexec" --line

Write-Host "Part C: "

Write-Host "Recent user logins"
osqueryi "SELECT DISTINCT user, type, tty, time from logged_in_users WHERE USER != ''";

Write-Host "Get pid, name, parent, path from processes"
osqueryi "SELECT pid, name, parent, path FROM processes"

Write-Host "Look for suspicious activity"

osqueryi "SELECT pid,port,protocol,address FROM listening_ports where port!=0 and port!=80 and port != 443"
