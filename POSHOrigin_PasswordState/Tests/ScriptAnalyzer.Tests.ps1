$modulePath = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent

Describe 'Code Analysis' {
    Context 'Script Analyzer' {

        #It 'has 0 Script Analyzer warnings' {
        #    $results = Invoke-ScriptAnalyzer -Path $modulePath -Recurse -Severity Warning
        #    $results.Count | Should Be 0
        #}

        It 'has 0 Script Analyzer errors' {
            $results = Invoke-ScriptAnalyzer -Path $modulePath -Recurse -Severity Error
            $results.Count | Should Be 0
        }
    }
}