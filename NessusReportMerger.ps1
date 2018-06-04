<#
.SYNOPSIS
Merges multiple .nessus files into one file. 

.DESCRIPTION
Merges multiple .nessus files into one file.  The resulting file can be imported into Nessus again to genereate a single report. 

Inspired by: 
https://gist.github.com/mastahyeti/2720173 by Ben Toews
https://www.darkoperator.com/blog/2015/2/16/merging-nessus-xml-reports-with-powershell by Carlos Perez
By 0xPrime

.EXAMPLE
NessusReportMerger.ps1 
Runs with default variables for -filepath, -outputfilename and -reportname.
Merges the files in the current folder to the file "merged_nessus_report.nessus" and sets the report name to "Merged Report".

.EXAMPLE
NessusReportMerger.ps1 -filepath "C:\foo"
Runs with default variables for -outputfilename and -reportname. 
Merges the files in "C:\foo" to the file "merged_nessus_report.nessus" and sets the report name to "Merged Report".

.EXAMPLE
NessusReportMerger.ps1 -reportname "FooReport"
Runs with default variables for -filepath and -outputfilename.
Merges the files in the current folder to the file "merged_nessus_report.nessus" and sets the report name to "FooReport".

.EXAMPLE
NessusReportMerger.ps1 -filepath "C:\foo" -outputfilename "FooReport.nessus" -reportname "FooReport"
Merges the files in the "C:\foo" folder to the file "FooReport.nessus" and sets the report name to "FooReport".
#>

Param
(
    # Path to the files. Defaults to the current path. 
    [string] $filepath = (Resolve-Path .\).Path,
    # Output file name. Defaults to merged_nessus_report.nessus.
    [string] $outputfilename = "merged_nessus_report.nessus",
    # Name of the merged report. Defaults to Merged Report.
    [string] $reportName = "Merged Report"
)

Write-Host Merging .nessus files in folder $filepath 

# Get all .nessus files
$files = Get-ChildItem $filepath -Filter *.nessus

# Check if the folder contains .nessus files
if ($files.count -eq 0) 
{
    Write-Host No .nessus files detected in $filepath -f Red
}
else
{
    foreach ($file in $files)
    {
        # Check if this is the first file
        if ($files.IndexOf($file) -eq 0)
        {
            Write-Host Selected $file as primary -f Green
            Write-Host Parsing $file -f Green
            [xml]$mergedReport = Get-Content -Path $file
        }
        else
        {
            Write-Host Parsing $file -f Green
            
            # Get all the ReportHost nodes from the XML
            [xml]$report = Get-Content -Path $file
            $reportHosts = $Report.NessusClientData_v2.Report.SelectNodes("ReportHost")
            
            foreach($reportHost in $reportHosts)
            {
                Write-Host + Adding host: $reportHost.Name  -f Green

                # Merge each host into the merged report. 
                $mergedReport.NessusClientData_v2.Report.AppendChild($mergedReport.ImportNode($reportHost, $true))
            }
        }    
    }
    # Set the report name.
    $mergedReport.NessusClientData_v2.Report.name = $reportName
    $outfile = $filepath + "\" + $outputfilename

    Write-Host Saving merged report to $outfile  -f Green 
    
    # Save the merged report to a file. 
    $mergedReport.Save($outfile)
}
