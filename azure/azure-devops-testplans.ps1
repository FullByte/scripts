<#
.SYNOPSIS
    Read and Update Azure DevOPs Testplans using REST API
	https://learn.microsoft.com/en-us/rest/api/azure/devops/testplan/configurations?view=azure-devops-rest-7.1
	User must be assigned "users Basic + Test Plans" Access Level
    DevOps PAT requires right to "Read & Write" in Scope "Test Management".
#>

Function ReadTestPlans
{
    Param(
        [Parameter(Mandatory=$true,
        HelpMessage="DevOps Organization Name aka the name in the URL when you open DevOps.")]
        [String]
        $OrganizationName,

        [Parameter(Mandatory=$true,
        HelpMessage="DevOps Project Name within the given DevOps Organization.")]
        [String]
        $ProjectName,
		
		[Parameter(Mandatory=$true,
        HelpMessage="DevOps PAT Token requires right for Test Management to read and write . Example token: 7dth7i7e4Apzy4adzcycgpznaw3kd4di3fh42T37hghetxvh77rq")]
        [String]
        $AzureDevOpsPAT
    )
	
	Begin {
		# get authentication header for REST
		$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }
	}
	
	Process {
		Write-Host("Scope is project: $ProjectName in DevOps organization $OrganizationName.") -ForegroundColor Green -BackgroundColor DarkGray
		$baseurl =  "https://dev.azure.com/" + $OrganizationName + "/" + $ProjectName 

		# get testplans
		$testplanurl = $baseurl + "/_apis/testplan/plans?api-version=7.1-preview.1"
		$testplans = (Invoke-RestMethod -Uri $testplanurl -Method GET -Headers $AzureDevOpsAuthenicationHeader).value
		Write-Host($testplans)

		foreach ($testplan in $testplans){
			$testsuiteurl = $baseurl + "/_apis/testplan/Plans/" + $testplan.id + "/suites?api-version=7.1-preview.1"

			$testsuits = (Invoke-RestMethod -Uri $testsuiteurl -Method GET -Headers $AzureDevOpsAuthenicationHeader).value
			Write-Host($testsuits)
		}
	}
}

DeleteDevOpsInternalWiki OrganizationName ProjectName AzureDevOpsPAT

