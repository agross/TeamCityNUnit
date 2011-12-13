$framework = '4.0'

task default -depends Test

task Test -Depends Compile, Clean {
  New-Item test-results -Type Directory
  
  Get-ChildItem -Path source/**/bin -Recurse -Include Tests*.dll | `
    ForEach-Object {
      exec { .\packages\NUnit.2.5.10.11092\tools\nunit-console.exe /nologo /xml:test-results\$($_.Name).html $_ }
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
