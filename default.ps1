task default -depends Compile

task Test -Depends Compile, Clean {
  "This is a test"
}

task Compile -Depends Clean {
  exec { msbuild /target:Build /nologo /verbosity:Quiet TeamCityNUnit.sln }
}

task Clean {
  foreach ($glob in ('source/**/bin', 'source/**/obj'))
  {
    Remove-Item $glob -recurse -force -ErrorAction SilentlyContinue
  }
}
