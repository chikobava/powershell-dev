Configuration HelloWorld {

    # Import the module that contains the File resource.
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    $Kevin = Import-PowerShellDataFile .\Kevin.psd1
    $Simone = Import-PowerShellDataFile .\Simone.psd1
    # The Node statement specifies which targets to compile MOF files for, when
    # this configuration is executed.
    Node 'localhost' {
        # The File resource can ensure the state of files, or copy them from a
        # source to a destination with persistent updates.
        File HelloWorld {
            DestinationPath = "$env:helloFile"
            Ensure          = "Present"
            Contents        = "Kevin is from $($Kevin.City) and Simone is from $($Simone.City)"
        }
    }
}