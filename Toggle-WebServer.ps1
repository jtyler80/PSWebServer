$WebServerFilePath = "C$\Web\www.fourthhospitality.com"
$LBPageName = "lb_session.htm"


function Connect-RemotePSWeb
{
    [CmdletBinding()]
    param
    (
    [Parameter(Mandatory)]
    [ValidateScript({
        Test-Connection $_ -Count 1 -Quiet        
    })]
    [System.Net.IPAddress]$PSWebIP
    )
    
    $User = "Administrator"
    $PasswordFile = "C:\Scripts\MyScripts\TechOps\Password.txt"
    $KeyFile = "C:\Scripts\MyScripts\TechOps\AES.key"
    $key = Get-Content $KeyFile
    $PSAdminCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)


    $PSWebSession = New-PSSession -ComputerName $PSWebIP -Credential $PSAdminCreds
}




function Toggle-WebServer
{
    [CmdletBinding()]
    param
    (
    [Parameter(Mandatory)]
    [ValidateScript({
        if (-not (Test-Path -Path "\\$_\$WebServerFilePath" -PathType Container))
        {
            throw "Cannot find the People System folder on $_ , either it does not exist or server is offline.."
        }
        else
        {
            $true
        }
    })]
    [String]$PSServerIP
    )

    $PSServerIPFilePath = "\\$PSServerIP\$WebServerFilePath"
    
    If (Test-Path -Path "$PSServerIPFilePath\$LBPageName") 
    {
        Write-Verbose "$LBPageName exists."
    }
    else
    {
        Write-Verbose "$LBPageName does not exist."
        $filelist = Get-ChildItem -Path "C:\web\www.fourthhospitality.com\lb_session*.*"
        foreach ($file in $filelist)
        {
            If ($file -like "support@fourthhospitality.com")
            {
                write-host "file found"
            }
        }
    }
}
