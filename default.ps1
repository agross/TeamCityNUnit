$framework = '4.0'
$nunit = './packages/NUnit.2.5.10.11092/tools'

# IMPORTANT: We need to use ${env:blah} because the environent variable contains dots. I <3 PowerShell.
#
# Please see TeamCity Configuration.png, it shows how to set up the required NUnit environent variable
# for PowerShell.
#
$running_in_teamcity = ${env:teamcity.dotnet.nunitaddin} -ne $null

task default -depends Test

task TeamCity -precondition { return $running_in_teamcity } {
  $regex = [regex]"(?i)NUnit\.(?<Version>\d+\.\d+\.\d+)\.\d+"
  $nunit -match $regex
  $nunitVersion = $matches.Version
  
  New-Item $nunit\addins -Type Directory -Force
    
  $teamCityAddinPath = ${env:teamcity.dotnet.nunitaddin}
  Copy-Item $teamCityAddinPath-$nunitVersion.* -Destination $nunit\addins
}

task Test -Depends TeamCity, Compile, Clean {
  New-Item test-results -Type Directory

  Get-ChildItem -Path source/**/bin -Recurse -Include Tests*.dll | `
    ForEach-Object {
      exec { &("$nunit/nunit-console.exe") /nologo /xml:test-results/$($_.Name).xml $_ }
    }
}

task Compile -Depends Clean {
  exec { msbuild /target:Build /nologo /verbosity:Quiet TeamCityNUnit.sln }
}

task Clean {
  foreach ($glob in ('source/**/bin', 'source/**/obj', 'test-results'))
  {
    Remove-Item $glob -recurse -force -ErrorAction SilentlyContinue
  }
}
