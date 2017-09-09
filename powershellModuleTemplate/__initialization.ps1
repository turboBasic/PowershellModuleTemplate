#
# this file is dot sourced by module root file (ModuleName.psm1) during import
#


# this function is dot sourced by Module.psm1 immediately after initialization of
# $ScriptPath variable
function __afterStart {
    "__afterStart()" | Write-Verbose


    # Module variables
    [String] $variable1 = 'xxx'             # @TODO Populate template variable
    [Int32]  $variable2 = 777               # @TODO Populate template variable
    [String] $notExportableVar = 'foo'

    $config.exportVariables = @( 
        'variable1',
        'variable2'
    )

    # map function names to aliases
    $config.exportAliases = @{
        'Test-Update' =            'alias'
        'PublicFunctionExample' =  'can', 'have', 'multiple', 'aliases'
    }

    # Create Drives
    

    # custom Data types
    
}





# this function is dot sourced after importing functions from ./_src/{public, private}/*.ps1 
# and before module exports its public functions and variables.
#
# if you want to update/initialize variables which depend on functions from  
# ./_src/{public, private}/*.ps1, this is the right place to do so
function __beforeExport {
    "__beforeExport()" | Write-Verbose

}






# this function is dot sourced by Module.psm1 immediately after Exporting all
# functions, variables and aliases. Delete artifacts created during initialization
# which are not needed afterwards
function __beforeFinish {
    " __beforeFinish()" | Write-Verbose

}