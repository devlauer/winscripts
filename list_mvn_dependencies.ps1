$listfile="c:\temp\test\mvndep.txt"
$listresult="c:\temp\mvndep.result.txt"
$treefile="c:\temp\mvntree.txt"

if (!(Test-Path $listfile))
{
   $path = split-path -parent $listfile
   New-Item $path -type "directory"
   New-Item $listfile -type "file" 
}
if (!(Test-Path $listresult))
{
   $path = split-path -parent $listresult
   New-Item $path -type "directory"
}
if (!(Test-Path $treefile))
{
   $path = split-path -parent $listfile
   New-Item $path -type "directory"
   New-Item $treefile -type "file" 
}
$files = Get-ChildItem -Path . -Filter pom.xml -Recurse -ErrorAction SilentlyContinue
foreach($file in $files) 
{ 
    set-location -path $file.Directory.FullName
    mvn dependency:list -DoutputFile=$listfile -DappendOutput=true -Dsilent=true -Dsort=true
    add-content $treefile $file.FullName
    mvn dependency:tree -DoutputFile=$treefile -DappendOutput=true 
}
get-content $listfile | sort | get-unique | Out-File $listresult