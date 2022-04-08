function copyImageToProd{
    Param(
        [Parameter(Mandatory=$True)]
        [String]$ImageVersionName,

        [Parameter(Mandatory=$True)]
        [String]$ImageDefinitionName,

        [Parameter(Mandatory=$True)]
        [String]$DevGalleryName,

        [Parameter(Mandatory=$True)]
        [String]$DevResourceGroupName,

        [Parameter(Mandatory=$True)]
        [String]$ProdGalleryName,

        [Parameter(Mandatory=$True)]
        [String]$ProdResourceGroupName,

        [String]$location = 'westeurope'
    )

    # Preparing variables
    $sourceImgVer = Get-AzGalleryImageVersion -GalleryImageDefinitionName $ImageDefinitionName -GalleryName $DevGalleryName -ResourceGroupName $DevResourceGroupName -Name $ImageVersionName
    $destinationImgDef  = Get-AzGalleryImageDefinition -GalleryName $ProdGalleryName -ResourceGroupName $ProdResourceGroupName -Name $ImageDefinitionName
    $region1 = @{Name=$location;ReplicaCount=1}
    $targetRegions = @($region1)

    # Starting copy job
    New-AzGalleryImageVersion -ResourceGroupName $ProdResourceGroupName -GalleryName $ProdGalleryName -GalleryImageDefinitionName $destinationImgDef.Name -GalleryImageVersionName $ImageVersionName -Location $location -TargetRegion $targetRegions -Source $sourceImgVer.Id.ToString()
}

copyImageToProd '1.0.0' 'ImageDefinition' 'sig-dev' 'rg-sig-dev' 'sig-prod' 'rg-sig-prod'