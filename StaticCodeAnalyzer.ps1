$SolutionFilePath = 'C:\Users\Administrator\Downloads\dvna-master\dvna-master'
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$SolutionFileName = 'scb-test'
$path = 'C:\Users\Administrator\Downloads\dvna-master\' + $SolutionFileName + '.fpr'
$BuildIdName = 'js10'
$sscURL = 'http://192.168.11.53:8081/ssc/'
$applicationVersionID = '10003'
$sscToken = 'YTk4NTQ2MDctMzliMC00MDk2LTkyNDUtOTVhOWM2ZTAyNjY4'
Write-Host -ForegroundColor Green ("Project Name :" + $ProjectName)
cd \
cd "$SolutionFilePath"

sourceanalyzer -verbose -b $BuildIdName -clean
sourceanalyzer -verbose -b $BuildIdName -source 11 -libdirs **/* **/* 
sourceanalyzer -verbose -b $BuildIdName -scan -f $path
 Write-Host ("Export Fpr...")

    #4. Upload the Results to SSC
    $sscheaders = '@{
        "Authorization" = "FortifyToken '+ $sscToken + '"
        "ContentType" = "multipart/form-data"
        "accept" = "application/json"
    }'
    $sscheader_exp = Invoke-Expression $sscheaders
    $sscuploadurl = $sscURL + 'api/v1/projectVersions/' + $applicationVersionID + '/artifacts'

    Write-Host ("Starting Upload to SSC...")
    Invoke-RestMethod -uri $sscuploadurl -Method POST -Headers $sscheader_exp -Form @{file=(Get-Item $path)}
    Write-Host -ForegroundColor Green ("Finished! Scan Results are now availible in the Software Security Center!")
