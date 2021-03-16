echo "===`ndev.ps1 - Main Development Environment PowerShell script`n==="
#echo "Press any key to start."
#$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null

# download scoop
echo "`n-> Downloading scoop...`n"
# in case of emergency, break the # below
#Set-ExecutionPolicy RemoteSigned -scope CurrentUser -force
iwr -useb get.scoop.sh | iex

# buckets
echo "`n--------------------`n-> Building buckets list..."
$buckets = 'extras','java','nonportable'

# apps
echo "-> Building apps list..."

# essentials + qol
$apps = 'notepadplusplus','discord','firefox','opera'

# general dev shit
$apps += 'vscode','gitkraken','insomnia'

# java
$apps += 'adoptopenjdk-hotspot','maven'

# python? just python, conda is a clusterfuck
$apps += 'python'

echo "-> Installing git`n"
& scoop install git

echo "`n--------------------`n-> Enabling buckets...`n"
foreach ($bucket in $buckets) {
  echo "---`n-> Enabling bucket: $bucket`n---"
  & scoop bucket add $bucket
}

echo "`n--------------------`n-> Installing apps...`n"
foreach ($app in $apps) {
  echo "---`n-> Installing app: $app`n---"
  & scoop install $app
}

# since the vcredist2019 downloaded by scoop is simply the installer (which then gets called during the install script),
# you can safely uninstall it afterwards without removing the redist binaries.
echo "`n--------------------`n-> Installing VCRedist 2019: You might be prompted for admin rights!`n"
& scoop install vcredist2019
& scoop uninstall vcredist2019

# basic profile for 'pyenv' command
echo "`n--------------------`n-> Writing basic 'pyenv' command script for python virtual envs placed under $env:userprofile\envs\"
try {
  echo "function Activate-Pyenv`n{`n  param(`$VenvName)`n  & \`"$env:userprofile\envs\`$VenvName\Scripts\Activate.ps1\`" | iex`n}`n`nNew-Item -Path Alias:pyenv -Value Activate-Pyenv | Out-Null" | Out-File -FilePath $env:userprofile\Documents\WindowsPowerShell\profile.ps1 -Append
}
catch [System.IO.DirectoryNotFoundException] {
  mkdir $env:userprofile\Documents\WindowsPowerShell | Out-Null
  echo "function Activate-Pyenv`n{`n  param(`$VenvName)`n  & \`"$env:userprofile\envs\`$VenvName\Scripts\Activate.ps1\`" | iex`n}`n`nNew-Item -Path Alias:pyenv -Value Activate-Pyenv | Out-Null" > $env:userprofile\Documents\WindowsPowerShell\profile.ps1
}
catch {
  echo "Failure! The following exception was thrown:`n`n $_"
}

echo "===`nAll done. Happy coding!`n===" #Press any key to exit.`n==="
#$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
