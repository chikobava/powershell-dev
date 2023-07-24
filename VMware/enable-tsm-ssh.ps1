<#
    .Synopsis
    Enables/Disables TSM-SSH Service on provided VM Hosts (ESXis) and turns disables 'lockdown mode'.
    Use this functions only for temporary maintanence. 
    Do not forget do disable SSH and put your hosts into lockdown mode, after you are done.

    .Description
    These two function disable / enable TSM-SSH service on the provided ESXis.
    They also accept input from pipeline.
    So you could:

    . ./enable-tsm-ssh.ps1 (this will import the functions into your current session)
    and then: 
    
    Get-VMHost -Location yourcluster | Enable-TSM-SSH

    This will enable TSM-SSH on every host in the yourcluster.

    .Example
    Get-VMHost -Location yourcluster | Disable-TSM-SSH

#>
function Enable-TSM-SSH {
    param (
        [Parameter(ValueFromPipeline=$true)]
        $vm_hosts
    )
    PROCESS {
        foreach ($vmhost in $vm_hosts) {
            $tsm = Get-VMHostService -VMHost $vmhost | Where-Object { $_.Key -eq "TSM" }
            $tsm_ssh = Get-VMHostService -VMHost $vmhost | Where-Object { $_.Key -eq "TSM-SSH" }
            Start-VMHostService $tsm
            Start-VMHostService $tsm_ssh
            (Get-View $vmhost).ExitLockdownMode()
        }
    }
}

function  Disable-TSM-SSH {
    param (
        [Parameter(ValueFromPipeline=$true)]
        $vm_hosts
    )
    PROCESS{
        foreach ($vmhost in $vm_hosts) {
            $tsm = Get-VMHostService -VMHost $vmhost | Where-Object { $_.Key -eq "TSM" }
            $tsm_ssh = Get-VMHostService -VMHost $vmhost | Where-Object { $_.Key -eq "TSM-SSH" }
            Stop-VMHostService $tsm -Confirm:$false
            Stop-VMHostService $tsm_ssh -Confirm:$false
            (Get-View $vmhost).EnterLockdownMode()
        }
    }
}