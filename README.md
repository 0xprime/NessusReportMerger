# Nessus Report Merger

Merges multiple .nessus files into one file.  The resulting file can be imported into Nessus again to genereate a single report.

## Examples
`NessusReportMerger.ps1`
Runs with default variables for -filepath, -outputfilename and -reportname.
Merges the files in the current folder to the file "merged_nessus_report.nessus" and sets the report name to "Merged Report".

`NessusReportMerger.ps1 -filepath "C:\foo"`
Runs with default variables for -outputfilename and -reportname.
Merges the files in "C:\foo" to the file "merged_nessus_report.nessus" and sets the report name to "Merged Report".

`NessusReportMerger.ps1 -reportname "FooReport"`
Runs with default variables for -filepath and -outputfilename.
Merges the files in the current folder to the file "merged_nessus_report.nessus" and sets the report name to "FooReport".

`NessusReportMerger.ps1 -filepath "C:\foo" -outputfilename "FooReport.nessus" -reportname "FooReport"`
Merges the files in the "C:\foo" folder to the file "FooReport.nessus" and sets the report name to "FooReport".

## Inspired by:
https://gist.github.com/mastahyeti/2720173 by Ben Toews
https://www.darkoperator.com/blog/2015/2/16/merging-nessus-xml-reports-with-powershell by Carlos Perez
