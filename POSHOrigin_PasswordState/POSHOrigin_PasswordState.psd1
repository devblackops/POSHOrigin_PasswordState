@{
RootModule = 'POSHOrigin_PasswordState.psm1'
ModuleVersion = '1.0'
GUID = 'bd4390dc-a8ad-4bce-8d69-f53ccf8e4163'
Author = 'Brandon Olin'
Copyright = '(c) 2016 Brandon Olin. All rights reserved.'
Description = "POSHOrigin_PasswordState is a set of PowerShell 5 based DSC resources for managing ClickStudio's PasswordState application via DSC. These resources are designed to be used with POSHOrigin as a Infrastructure as Code framework, but can be used natively by standard DSC configurations as well. Integration with POSHOrigin is accomplished via a separate Invoke.ps1 script included in the module."
PowerShellVersion = '5.0'
RequiredModules = @('PasswordState')
DscResourcesToExport = @('PasswordList', 'Password')
PrivateData = @{
        PSData = @{
            ProjectUri = 'https://github.com/devblackops/POSHOrigin_PasswordState'
            LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'
            Tags = @(
                'Desired State Configuration',
                'DSC',
                'POSHOrigin',
                'PasswordState',
                'Credential',
                'Infrastructure as Code',
                'IaC'
            )
        }
    }
}