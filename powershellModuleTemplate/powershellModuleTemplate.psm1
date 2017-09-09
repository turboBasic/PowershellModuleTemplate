#
# Module xxxxxxx / SelfServiceModule template
# (c) 2017 Andriy Melnyk. All rights reserved.
#

$config = @{}
$config.ScriptPath = $PSScriptRoot                              # current script path & source root of project
$config.Public =     Join-Path $config.ScriptPath Public
$config.Private =    Join-Path $config.ScriptPath Private
# user variables and logic to be injected in the module
$config.initScript = Join-Path $config.ScriptPath __initialization.ps1
$config.afterStartFunction =   '__afterStart'
$config.beforeExportFunction = '__beforeExport'
$config.beforeFinishFunction = '__beforeFinish'




# dot source user-modifiable initialization script with 3 functions inside:
# __afterStart(), __beforeExport()and __beforeFinish()
if(Test-Path $config.initScript) {
    . $config.initScript
}


# dot source code which should execute before everything
if(Test-Path Function:/$($config.afterStartFunction)) {
    . $config.afterStartFunction
}


#region         dot source private and public functions from files        
    [array]$__public =  Get-ChildItem -path "$($config.ScriptPath)/Public" -file -recurse -filter "*.ps1"
    [array]$__private = Get-ChildItem -path "$($config.ScriptPath)/Private" -file -recurse -filter "*.ps1"

    $__private + $__public | 
        ForEach-Object {
            $__currentItem = $_.fullName
            Try {
                . $__currentItem
            }
            Catch {
                Write-Error -message "Failed to import file ${__currentItem}: $_"
            }
        }

    # Find all Public functions defined no deeper than the first level deep and export it.
    # credits to https://www.the-little-things.net/blog/2015/10/03/powershell-thoughts-on-module-design/
    $__public |
        ForEach-Object {
            ( [System.Management.Automation.Language.Parser]::ParseInput( 
                            (Get-Content -path $_.fullName -raw), 
                            [ref]$null, 
                            [ref]$null
              )
            ).FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) | 
                ForEach-Object {
                    $__currentItem = $_.Name
                    Try {
                        Export-ModuleMember -function $__currentItem
                    }
                    Catch {
                        Write-Error -message "Failed to export function ${__currentItem}: $_"
                    }
                }
        }

    Remove-Item  Variable:\__currentItem -ErrorAction SilentlyContinue

#endregion


# create aliases according to list populatef by $config.afterStartFunction()
foreach( $function in $config.exportAliases.Keys) {
    foreach($alias in $config.exportAliases[$function]) {
        New-Alias -name $alias -value $function
        Export-ModuleMember -alias $alias
    }
}





# eg. update/initialize variables which depend on functions internal to the module
# i.e. available only after importing them to the module. This is the right place to do so.
if( Test-Path Function:/$($config.beforeExportFunction) ) {
    . $config.beforeExportFunction
}






<# Here I might...
        Read in or create an initial config file and variable
        Export Public functions ($Public.BaseName) for WIP modules
        Set variables visible to the module and its functions only
#>

# export all available aliases as aliases in module make sense only if they are exported

Export-ModuleMember -variable $config.exportVariables




if(Test-Path Function:/$($config.beforeFinishFunction)) {
    . $config.beforeFinishFunction
}
