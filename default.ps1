task default -depends Compile

task Test -Depends Compile, Clean {
  "This is a test"
}

task Compile -Depends Clean {
  exec { msbuild /t:Clean /t:Build /v:q /nologo TeamCityNUnit.sln }
}

task Clean {
  foreach ($glob in ('source/**/bin', 'source/**/obj'))
  {
    Remove-Item $glob -recurse -force -ErrorAction SilentlyContinue
  }
}
