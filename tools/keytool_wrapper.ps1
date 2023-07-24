# this variable must be set to the location of java keytool
$keytool = "$env:JRE_HOME\bin\keytool.exe"

function Read-Certificates-Default-Java-Keystore {
    param(
        [string]$alias,
        [string]$storepass
    )
    $keystore = "$env:JRE_HOME\lib\security\cacerts"
    $arguments = "-list -alias $alias -v -keystore '$keystore' -storepass $storepass"
    Invoke-Expression "& '$keytool' $arguments"
}

function Remove-Certificate-From-Default-Java-Keystore {
    param(
        [string]$alias,
        [string]$storepass
    )
    $keystore = "$env:JRE_HOME\lib\security\cacerts"
    $arguments = "-delete -alias $alias -keystore '$keystore' -storepass $storepass"
    Invoke-Expression "& '$keytool' $arguments"
}

function Get-Public-Key-From-PKCS12-Store {
    param(
        [string]$alias,
        [string]$storepass,
        [string]$keystore,
        [string]$file
    )
    $arguments = "-export -keystore '$keystore' -alias $alias -file '$file' -storepass '$storepass'"
    Invoke-Expression "& '$keytool' $arguments"
}

function Import-To-Default-Java-Keystore {
    param(
        [string]$alias,
        [string]$storepass,
        [string]$pathToCert
    )
    $keystore = "$env:JRE_HOME\lib\security\cacerts"
    $arguments = "-importcert -noprompt -file $pathToCert -alias $alias -keystore '$keystore' -storepass $storepass"
    Invoke-Expression "& '$keytool' $arguments"
}
