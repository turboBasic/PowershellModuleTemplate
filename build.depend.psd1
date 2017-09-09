@{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target = '$DependencyFolder'
    }

    'psake' =            @{ DependencyType = 'psGalleryModule' }
    'psDeploy' =         @{ DependencyType = 'psGalleryModule' }
    'psScriptAnalyzer' = @{ DependencyType = 'psGalleryModule' }
    'BuildHelpers' =     @{ DependencyType = 'psGalleryModule' }
    'Pester' =           @{ DependencyType = 'psGalleryModule' }
}