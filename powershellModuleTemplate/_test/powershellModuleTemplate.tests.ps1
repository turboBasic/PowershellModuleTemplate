#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests. 
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#
$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}

$PSVersion = $PSVersionTable.PSVersion.Major
#Import-Module $PSScriptRoot/../PowershellModuleTemplate -Force


Describe "Exports public functions" {
    It "should be no public functions available in the beginning" {
        Get-Module PowershellModuleTemplate | Should BeNullOrEmpty
        Test-Path Function:/PublicFunctionExample | Should Be $false
        "Function:/Test-Update" | Should Not Exist
    }

    It "should be no exported variables in Global scope" {
        Get-Module PowershellModuleTemplate | Should BeNullOrEmpty
        "Variable:/variable1" | Should Not Exist
        "Variable:/variable2" | Should Not Exist
    }

    It "should be no exported aliases" {
        Get-Module PowershellModuleTemplate | Should BeNullOrEmpty
        "Alias:/can" | Should Not Exist
        "Alias:/multiple" | Should Not Exist
    }

    It "should be variable after import" {
        Import-Module PowershellModuleTemplate -Force 
        $variable1 | Should be 'xxx'
    }

    It "should be no private variable after import" {
        Import-Module PowershellModuleTemplate -Force 
        Get-Item Variable:/notExportableVar -EA SilentlyContinue | Should Be $null
    }

    BeforeEach {
        if (Get-Module PowershellModuleTemplate) {
            Remove-Module PowershellModuleTemplate 
        }
    }

}
