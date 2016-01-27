<#
    This script expects to be passed a psobject with all the needed properties
    in order to invoke 'Active Directory DNS' DSC resources.
#>
[cmdletbinding()]
param(
    [parameter(mandatory)]
    [psobject]$Options,

    [bool]$Direct = $false
)

# Ensure we have a valid 'ensure' property
if ($null -eq $Options.options.Ensure) {
    $Options.Options | Add-Member -MemberType NoteProperty -Name Ensure -Value 'Present' -Force
}

# Get the resource type
$type = $Options.Resource.split(':')[1]

$hash = @{
    Endpoint = $Options.options.Endpoint
    Ensure = $Options.options.Ensure
}

# Credentials may be specified in line. Test for that
if ($Options.options.ApiKey -is [pscredential]) {
    $hash.ApiKey = $Options.options.ApiKey
}

# Credentials may be listed under secrets. Test for that
if ($Options.options.secrets.ApiKey) {
    $hash.ApiKey = $Options.options.secrets.ApiKey.credential
}

# Have PasswordState generate a random password if we didn't supply one
if ($null -ne $Options.options.Password) {
    $hash.Password = $Options.options.Password
} else {
    $hash.GeneratePassword = $true
}

switch ($type) {
    'Password' {
        if ($Direct) {
            $hash.PasswordListId = $Options.options.PasswordListId
            $hash.Title = $Options.options.Title
            $hash.Username = $Options.options.Username
            $hash.Description = $Options.options.Description
            $hash.GenericField1 = $Options.options.GenericField1
            $hash.GenericField2 = $Options.options.GenericField2
            $hash.GenericField3 = $Options.options.GenericField3
            $hash.GenericField4 = $Options.options.GenericField4
            $hash.GenericField5 = $Options.options.GenericField5
            $hash.GenericField6 = $Options.options.GenericField6
            $hash.GenericField7 = $Options.options.GenericField7
            $hash.GenericField8 = $Options.options.GenericField8
            $hash.GenericField9 = $Options.options.GenericField9
            $hash.GenericField10 = $Options.options.GenericField10
            $hash.Notes = $Options.options.Notes
            $hash.AccountTypeID = $Options.options.AccountTypeID
            $hash.Url = $Options.options.Url
            $hash.ExpiryDate = $Options.options.ExpiryDate
            $hash.AllowExport = $Options.options.AllowExport
            return $hash
        } else {
            $confName = "$type" + '_' + $Options.Name
            Write-Verbose -Message "Returning configuration function for resource: $confName"
            Configuration $confName {
                Param (
                    [psobject]$ResourceOptions
                )

                Import-DscResource -Name Password -ModuleName POSHOrigin_PasswordState

                # Credentials may be specified in line. Test for that
                if ($ResourceOptions.Options.ApiKey) {
                    $cred = $ResourceOptions.Options.ApiKey
                }

                # Credentials may be listed under secrets. Test for that
                if ($ResourceOptions.options.secrets.ApiKey) {
                    $cred = $ResourceOptions.options.secrets.ApiKey
                }

                # Have PasswordState generate a random password if we didn't supply one
                    if ($null -ne $Options.options.Password) {
                    $Password = $Options.options.Password
                    $GeneratePassword = $false
                } else {
                    $Password = $null
                    $GeneratePassword = $true
                }


                Password $ResourceOptions.Name {
                    Ensure = $ResourceOptions.options.Ensure
                    Title = $ResourceOptions.options.Title
                    Endpoint = $ResourceOptions.options.Endpoint
                    ApiKey = $cred
                    PasswordListId = $ResourceOptions.options.PasswordListId
                    Username = $ResourceOptions.options.Username
                    GeneratePassword = $GeneratePassword
                    Password = $password
                    Description = $ResourceOptions.options.Description
                    GenericField1 = $ResourceOptions.options.GenericField1
                    GenericField2 = $ResourceOptions.options.GenericField2
                    GenericField3 = $ResourceOptions.options.GenericField3
                    GenericField4 = $ResourceOptions.options.GenericField4
                    GenericField5 = $ResourceOptions.options.GenericField5
                    GenericField6 = $ResourceOptions.options.GenericField6
                    GenericField7 = $ResourceOptions.options.GenericField7
                    GenericField8 = $ResourceOptions.options.GenericField8
                    GenericField9 = $ResourceOptions.options.GenericField9
                    GenericField10 = $ResourceOptions.options.GenericField10
                    Notes = $ResourceOptions.options.Notes
                    AccountTypeID = $ResourceOptions.options.AccountTypeID
                    Url = $ResourceOptions.options.Url
                    ExpiryDate = $ResourceOptions.options.ExpiryDate
                    AllowExport = $ResourceOptions.options.AllowExport
                }
            }
        }
    }
}

