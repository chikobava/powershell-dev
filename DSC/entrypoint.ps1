echo $env:workingDir
"Starting host conifguration"
"Calling powershell Start-DSCConfiguration command"
"Importing the function: "
. .\HelloWorld.ps1
"Calling the HelloWorld function"
HelloWorld
"Generating configuration"
Start-DSCConfiguration -Path "$env:workingDir\HelloWorld" -Wait
"Checking configuration"
Get-Content $env:helloFile 