$Pattern = "Template"
$Replace = "MyLibrary"

$files_to_replace = Get-ChildItem .\ -Recurse -Include ("*.sln", "*.csproj", "*.vcxproj", "*.Build.props", "*.cpp", "*.cxx", "*.h", "*.i", "*.cs")

foreach ($file in $files_to_replace)
{
    $fileContent = Get-Content -Path $file.FullName

	# replace the contents of the files only if there is a match
    if ($fileContent -match $Pattern)
    {
        $newFileContent = $fileContent -replace $Pattern, $Replace
        Set-Content -Path $file.FullName -Value $newFileContent
    }
	
	# iterate through the files and change their names
    if ($file -match $Pattern)
    {
        $newName = $file.Name -replace $Pattern, $Replace
        Rename-Item -Path $file.FullName -NewName $newName
    }
}

# change the names of the files first then change the names of the directories
# reverse the array of directories so we go deepest first
# this stops us renaming a parent directory then trying to rename a sub directory which will no longer exist
$directorys = Get-ChildItem .\ -Directory -Recurse
[array]::Reverse($directorys)

# iterate through the directories and change their names
foreach ($directory in $directorys)
{
    if ($directory -match $Pattern)
    {
        $newName = $directory.Name -replace $Pattern, $Replace
        Rename-Item -Path $directory.FullName -NewName $newName
    }
}