$me =          ($PSScriptRoot | Split-Path -Leaf) -replace '^Module_'
$sourceRoot =  Join-Path $PSScriptRoot $me
$profileDIR = Split-Path $profile -parent
$destRoot =    Join-Path $profileDIR "Modules/$me"
$scriptsRoot = Join-Path $profileDIR Scripts

Deploy AllScripts {                                # Deployment name. This needs to be unique. Call it whatever you want

    Remove-Module -force $me -errorAction SilentlyContinue
    if( -not(Test-Path $destRoot) ) { 
      $null = New-Item -path $destRoot -itemType Directory 
    } 
    
    By Filesystem {                                # Deployment type. See Get-PSDeploymentType
        FromSource  $sourceRoot/en_US   
        To          $destRoot/en_US
        WithOptions @{ Mirror=$True }
    }

    By Filesystem {                               
        FromSource  $sourceRoot/private   
        To          $destRoot/private
        WithOptions @{ Mirror=$True }
    }

    By Filesystem {                               
        FromSource  $sourceRoot/public   
        To          $destRoot/public
        WithOptions @{ Mirror=$True }
    }

    By Filesystem {                               
        FromSource  $sourceRoot/*.ps1, $sourceRoot/*.psm1, $sourceRoot/*.psd1, $sourceRoot/*.ps1xml
        To          $destRoot
    }
}


