task default -depends Compile

task Test -Depends Compile, Clean {
  "This is a test"
}

task Compile -Depends Clean {
  exec { msbuild /t:Clean /t:Build /v:q /nologo TeamCityNUnit.sln }
}

task Clean {
  "Clean"
}
