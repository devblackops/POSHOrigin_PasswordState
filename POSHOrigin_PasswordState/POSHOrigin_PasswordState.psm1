#Requires -Version 5.0
#Requires -Module PasswordState

enum Ensure {
    Absent
    Present
}

# Import strings
$localizedParams = @{
    BaseDirectory = Join-Path -Path $PSScriptRoot -ChildPath Localized
    UICulture = Get-UICulture
}
$script:strings = Import-LocalizedData @localizedParams

[DscResource()]
class Password {
    [DscProperty(key)]
    [string]$Title

    [DscProperty()]
    [Ensure]$Ensure = [ensure]::Present

    [DscProperty(Mandatory)]
    [string]$Endpoint

    [DscProperty(Mandatory)]
    [string]$ApiKey

    [DscProperty(Mandatory)]
    [int]$PasswordListId

    [DscProperty()]
    [string]$UserName

    [DscProperty()]
    [bool]$GeneratePassword = $true

    [DscProperty()]
    [pscredential]$Password

    [DscProperty()]
    [string]$Description

    [DscProperty()]
    [string]$GenericField1
        
    [DscProperty()]
    [string]$GenericField2

    [DscProperty()]
    [string]$GenericField3

    [DscProperty()]
    [string]$GenericField4

    [DscProperty()]
    [string]$GenericField5

    [DscProperty()]
    [string]$GenericField6

    [DscProperty()]
    [string]$GenericField7

    [DscProperty()]
    [string]$GenericField8

    [DscProperty()]
    [string]$GenericField9

    [DscProperty()]
    [string]$GenericField10

    [DscProperty()]
    [string]$Notes

    [DscProperty()]
    [int]$AccountTypeID

    [DscProperty()]
    [string]$Url

    [DscProperty()]
    [string]$ExpiryDate

    [DscProperty()]
    [bool]$AllowExport

    [DscProperty(NotConfigurable)]
    [int]$PasswordId

    [Password]Get() {
        $result = [Password]::new()
        $result.Title = $this.Title
        $result.PasswordListId = $this.PasswordListId
        $result.EndPoint = $this.EndPoint
        $result.ApiKey = $this.ApiKey

        $keySecure = $this.ApiKey | ConvertTo-SecureString -AsPlainText -Force
        $apiKeyCred = New-Object System.Management.Automation.PSCredential -ArgumentList ('SecretAPIkey', $keySecure) 
        $params = @{
            Endpoint = $this.EndPoint
            PasswordListId = $this.PasswordListId
            ApiKey = $apiKeyCred
            Verbose = $false
        }
        Write-Verbose -Message "Finding record $($this.Title) in list $($this.PasswordListId)"
        $records = Get-PasswordStateListPasswords @params -ErrorAction SilentlyContinue

        $match = $records | where Title -eq $this.Title | Select-Object -First 1

        if ($match) {
            $result.Ensure = [Ensure]::Present
            $result.AccountTypeID = $match.AccountTypeId
            $result.AllowExport = $match.AllowExport
            $result.Description = $match.Description
            $result.ExpiryDate = $match.ExpiryData
            $result.GenericField1 = $match.GenericField1
            $result.GenericField2 = $match.GenericField2
            $result.GenericField3 = $match.GenericField3
            $result.GenericField4 = $match.GenericField4
            $result.GenericField5 = $match.GenericField5
            $result.GenericField6 = $match.GenericField6
            $result.GenericField7 = $match.GenericField7
            $result.GenericField8 = $match.GenericField8
            $result.GenericField9 = $match.GenericField9
            $result.GenericField10 = $match.GenericField10
            $result.Notes = $match.Notes
            $passSecure = $match.Password | ConvertTo-SecureString -AsPlainText -Force
            $result.Password = New-Object System.Management.Automation.PSCredential -ArgumentList ($this.Title, $passSecure)
            $result.PasswordId = $match.PasswordId
            $result.Url = $match.Url
            $result.Username = $match.Username
        } else {
            $result.Ensure = [Ensure]::Absent
            $result.PasswordId = $null
        }

        return $result
    }

    [void]Set() {
        $record = $this.Get()
        try {
            switch ($this.Ensure) {
                'Present' {
                    if ($record.Ensure -eq [ensure]::Present) {
                        #region Resource exists but lets test if we need to change anything on it
                        # TODO
                        #endregion
                    } else {
                        # Create record
                        $keySecure = $this.ApiKey | ConvertTo-SecureString -AsPlainText -Force
                        $apiKeyCred = New-Object System.Management.Automation.PSCredential -ArgumentList ('SecretAPIkey', $keySecure)
                        $params = @{
                            Endpoint = $this.Endpoint
                            ApiKey = $apiKeyCred
                            PasswordListId = $this.PasswordListId
                            Title = $this.Title
                            Username = $this.UserName
                            Description = $this.Description
                            GenericField1 = $this.GenericField1
                            GenericField2 = $this.GenericField2
                            GenericField3 = $this.GenericField3
                            GenericField4 = $this.GenericField4
                            GenericField5 = $this.GenericField5
                            GenericField6 = $this.GenericField6
                            GenericField7 = $this.GenericField7
                            GenericField8 = $this.GenericField8
                            GenericField9 = $this.GenericField9
                            GenericField10 = $this.GenericField10
                            Notes = $this.Notes
                            AccountTypeID = $this.AccountTypeID
                            Url = $this.Url
                            ExpiryDate = $this.ExpiryDate
                            AllowExport = $this.AllowExport
                            Verbose = $false
                        }
                        # Have PasswordState generate a random password if we didn't supply one
                        if ($null -ne $this.Password) {
                            $params.Password = $this.Password.Password
                        } else {
                            $params.GeneratePassword = $true
                        }

                        Write-Verbose -Message "Creating record $($this.Title) in list $($this.PasswordListId)"
                        $newPassword = New-PasswordStatePassword @params
                    }
                }
                'Absent' {
                    if ($record.Ensure = [ensure]::Present) {
                        # Delete record
                    } else {
                        # Do nothing
                    }
                }
            } 
        } catch {
          Write-Error -Message 'There was a problem setting the resource'
          Write-Error -Message "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
          Write-Error -Exception $_
        }
    }

    [bool]Test() {
        $record = $this.Get()
        Write-Verbose -Message "Validating that password $($this.Title) in list $($this.PasswordListId) is $($this.Ensure.ToString().ToLower())"
        if ($this.Ensure -ne $record.Ensure) {
            return $false
        }
        else {
            Write-Verbose -Message "$($this.Title) exists"
            # TODO Extra checks on existing entry
            return $true
        }
    }
}