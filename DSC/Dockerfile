FROM mcr.microsoft.com/powershell
ENV workingDir="C:/Project"
ENV helloFile="C:\Temp\HelloWorld.txt"
# to access environment variables in powershell you need to use $env: before any variable 
RUN powershell -command mkdir $env:workingDir

# in dockerfile commands simply use the name of the variable
COPY ./entrypoint.ps1 $workingDir/entrypoint.ps1
COPY ./data/* $workingDir/
COPY ./configuration/* $workingDir/
WORKDIR $workingDir
CMD [ "powershell", "-File", "entrypoint.ps1" ]
