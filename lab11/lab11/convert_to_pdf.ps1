$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = "None"

$reportsDir = "D:\PRM\PRMLAB\lab11\lab11\reports"
$wdFormatPDF = 17
$wdFormatDocumentDefault = 16

$files = @(
    @{ html = "$reportsDir\debugging_report.html"; pdf = "$reportsDir\debugging_report.pdf"; docx = "$reportsDir\debugging_report.docx" },
    @{ html = "$reportsDir\test_summary.html"; pdf = "$reportsDir\test_summary.pdf"; docx = "$reportsDir\test_summary.docx" }
)

foreach ($item in $files) {
    if (Test-Path $item.html) {
        Write-Host "Processing $($item.html)..."
        $doc = $word.Documents.Open($item.html)
        
        # Save as DOCX
        $doc.SaveAs2($item.docx, $wdFormatDocumentDefault)
        Write-Host "Saved: $($item.docx)"
        
        # Save as PDF
        $doc.ExportAsFixedFormat($item.pdf, $wdFormatPDF)
        Write-Host "Saved: $($item.pdf)"
        
        $doc.Close($false)
    }
}

$word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
Write-Host "Word conversion to DOCX and PDF finished successfully!"
