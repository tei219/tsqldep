# 
# returns available parsers 
# 
function parsers {
	param( $versions );
	
	# Prefer the ScriptDom DLL distributed with the repository; fall back to an installed assembly.
	$dllPath = Join-Path (Split-Path $PSScriptRoot -Parent) "Microsoft.SqlServer.TransactSql.ScriptDom.dll";
	if (Test-Path $dllPath) {
		$sqldom = [System.Reflection.Assembly]::LoadFrom($dllPath);
	} else {
		$sqldom = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.TransactSql.ScriptDom");
	}
	if (-not $sqldom) {
		write-host "[ERR ] Please install the SQLDOM.MSI from the SQL 2012 Feature Pack web page http://www.microsoft.com/en-us/download/details.aspx?id=35580" -foregroundcolor red
		exit;
	}
	
	# select available parser
	$create_flgs = [ordered] @{};
	if ($versions -eq $null) {
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql80Parser" } )) { $create_flgs.add("SQLServer2000", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql90Parser" } )) { $create_flgs.add("SQLServer2005", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql100Parser"} )) { $create_flgs.add("SQLServer2008", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql110Parser"} )) { $create_flgs.add("SQLServer2012", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql120Parser"} )) { $create_flgs.add("SQLServer2014", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql130Parser"} )) { $create_flgs.add("SQLServer2016", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql140Parser"} )) { $create_flgs.add("SQLServer2017", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql150Parser"} )) { $create_flgs.add("SQLServer2019", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql160Parser"} )) { $create_flgs.add("SQLServer2022", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql170Parser"} )) { $create_flgs.add("SQLServer2025", $true); }
		if ([bool] ($sqldom.gettypes() | where-object {$_.name -eq "TSql180Parser"} )) { $create_flgs.add("SQLServerNext", $true); }
	} else {
		# or select own
		foreach ($version in $versions) {
			if ( (($version -match  "80") -or ($version -match "2000")) -and (-not $create_flgs.contains("SQLServer2000")) ) { $create_flgs.add("SQLServer2000", $true); }
			if ( (($version -match  "90") -or ($version -match "2005")) -and (-not $create_flgs.contains("SQLServer2005")) ) { $create_flgs.add("SQLServer2005", $true); }
			if ( (($version -match "100") -or ($version -match "2008")) -and (-not $create_flgs.contains("SQLServer2008")) ) { $create_flgs.add("SQLServer2008", $true); }
			if ( (($version -match "110") -or ($version -match "2012")) -and (-not $create_flgs.contains("SQLServer2012")) ) { $create_flgs.add("SQLServer2012", $true); }
			if ( (($version -match "120") -or ($version -match "2014")) -and (-not $create_flgs.contains("SQLServer2014")) ) { $create_flgs.add("SQLServer2014", $true); }
			if ( (($version -match "130") -or ($version -match "2016")) -and (-not $create_flgs.contains("SQLServer2016")) ) { $create_flgs.add("SQLServer2016", $true); }
			if ( (($version -match "140") -or ($version -match "2017")) -and (-not $create_flgs.contains("SQLServer2017")) ) { $create_flgs.add("SQLServer2017", $true); }
			if ( (($version -match "150") -or ($version -match "2019")) -and (-not $create_flgs.contains("SQLServer2019")) ) { $create_flgs.add("SQLServer2019", $true); }
			if ( (($version -match "160") -or ($version -match "2022")) -and (-not $create_flgs.contains("SQLServer2022")) ) { $create_flgs.add("SQLServer2022", $true); }
			if ( (($version -match "170") -or ($version -match "2025")) -and (-not $create_flgs.contains("SQLServer2025")) ) { $create_flgs.add("SQLServer2025", $true); }
			if ( (($version -match "180") -or ($version -match "Next")) -and (-not $create_flgs.contains("SQLServerNext")) ) { $create_flgs.add("SQLServerNext", $true); }
		}
	}

	# create objects
	$parsers = [ordered] @{};
	foreach ($version in $create_flgs.keys) {
		if ($create_flgs[$version]) {
			switch($version) {
				"SQLServer2000" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql80Parser($false))); } 
				"SQLServer2005" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql90Parser($false))); } 
				"SQLServer2008" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql100Parser($false))); } 
				"SQLServer2012" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql110Parser($false))); } 
				"SQLServer2014" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql120Parser($false))); } 
				"SQLServer2016" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql130Parser($false))); }
				"SQLServer2017" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql140Parser($false))); }
				"SQLServer2019" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql150Parser($false))); }
				"SQLServer2022" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql160Parser($false))); }
				"SQLServer2025" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql170Parser($false))); }
				"SQLServerNext" { $parsers.add($version, $(new-object Microsoft.SqlServer.TransactSql.ScriptDom.TSql180Parser($false))); }
			}
		}
	}
	
	# returns hashtable, { SQLServer2000 => TSql80Parser-object, ... }
	return $parsers
}

Export-ModuleMember -Function parsers
