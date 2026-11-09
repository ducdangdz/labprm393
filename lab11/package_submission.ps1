param (
    [string]$StudentID = "SE180000",
    [string]$FullName = "DangHuynhDuc"
)

$projectDir = "D:\PRM\PRMLAB\lab11\lab11"
$zipName = "Module11_Testing_${StudentID}_${FullName}.zip"
$zipPath = "D:\PRM\PRMLAB\lab11\$zipName"

if (Test-Path $zipPath) {
    Remove-Item -Force $zipPath
}

# Create a clean temporary staging directory
$stageDir = "D:\PRM\PRMLAB\lab11\.staging"
if (Test-Path $stageDir) {
    Remove-Item -Recurse -Force $stageDir
}
New-Item -ItemType Directory -Path $stageDir | Out-Null

# Copy required items
Copy-Item -Recurse "$projectDir\lib" "$stageDir\lib"
Copy-Item -Recurse "$projectDir\test" "$stageDir\test"
Copy-Item -Recurse "$projectDir\screenshots" "$stageDir\screenshots"
Copy-Item -Recurse "$projectDir\reports" "$stageDir\reports"
Copy-Item "$projectDir\pubspec.yaml" "$stageDir\pubspec.yaml"
Copy-Item "$projectDir\analysis_options.yaml" "$stageDir\analysis_options.yaml"
Copy-Item "$projectDir\README.md" "$stageDir\README.md"

# Compress staging directory to zip
Compress-Archive -Path "$stageDir\*" -DestinationPath $zipPath -CompressionLevel Optimal

# Remove staging directory
Remove-Item -Recurse -Force $stageDir

Write-Host "Submission ZIP created successfully at: $zipPath"
