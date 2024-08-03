Import-Module ActiveDirectory

cd $PSScriptRoot

Do {
	$path = read-host -prompt 'File name'
		$valid = Test-Path -Path $path -PathType Leaf
		if (!$valid){
			echo "Not a valid path"
		}
}
Until($valid)

Try {
	$csv = import-csv -path $path
	$out_path = $path.replace('.csv','.out.csv')
	$fields = $csv[0].psobject.Properties.name
	$first_col = $fields[0]
	$input_arr = $csv.$first_col
	$unaliasedFields = $fields
}
Catch {
	Write-Host -ForegroundColor red "Csv formating is incorrect" 
	throw $_
}

#aliases for fields
$fields = $fields -ireplace "\busername\b","SamAccountName"
$fields = $fields -ireplace "\bemail\b", "EmailAddress"
$fields = $fields -ireplace "\bfirstname\b","Surname"
$fields = $fields -ireplace "\blastname\b","GivenName"

$in_type = $fields[0]
$output=@()

Try {
	$servers = get-content -path ".\servers.txt"
	$servers_arr = $servers -split " "
	foreach ($data in $input_arr) {
		foreach ($server in $servers_arr) {
			$output += Get-ADUser `
				-Filter "$in_type -eq '$data'" `
				-server $server `
				-Properties $fields
		}
	}
}

Catch {
	Write-Host -ForegroundColor red "A problem occured when fetching info from the AD" 
	throw $_
}

Try {
	$output | select $fields | export-csv -notypeinformation -delimiter ';' -path $out_path
	$content = get-content -path $out_path
	$content[0] = '"{0}"' -f ($unaliasedFields -join '";"')
	$content | set-content -path $out_path
}

Catch {
	Write-Host -ForegroundColor red "A problem occured while saving the file"
	throw $_
}

Finally {
	Write-Host -ForegroundColor green "Successfully wrote output to $out_path"
}
