Add-Type -AssemblyName System.IO.Compression.FileSystem
$files = Get-ChildItem -Path "C:\Users\NVT\Downloads" -Filter "*Proposition de progression coll*ge 2026-2028_041835.docx"
$docxPath = $files[0].FullName
$zip = [System.IO.Compression.ZipFile]::OpenRead($docxPath)
$entry = $zip.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xmlText = $reader.ReadToEnd()
$reader.Close()
$stream.Close()
$zip.Dispose()

# Load as XML
$xml = [xml]$xmlText

# Extract paragraphs
$paragraphs = $xml.SelectNodes('//*[local-name()="p"]')
foreach ($p in $paragraphs) {
    $texts = $p.SelectNodes('.//*[local-name()="t"]')
    if ($texts) {
        $line = ""
        foreach ($t in $texts) {
            $line += $t.'#text'
        }
        if ($line.Trim() -ne "") {
            Write-Output $line
        }
    }
}
