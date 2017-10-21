if "%ARCH%" == "32" (
  set ARCH=Win32
) else (
  set ARCH=x64
)

if "%VS_YEAR%" == "2008" (
  xcopy /s /y /i %RECIPE_DIR%\vs2008 %SRC_DIR%\builds\msvc\vs%VS_YEAR%
  copy %LIBRARY_INC%\stdint.h %SRC_DIR%\builds\msvc\
  copy %LIBRARY_INC%\inttypes.h %SRC_DIR%\builds\msvc\
  set ARTIFACTS_DIR=%SRC_DIR%\bin\x64\Release\v90\
  cd %SRC_DIR%\builds\msvc\vs%VS_YEAR%\dynamic
  msbuild libsodium.sln  /p:Configuration=Release /p:Platform=%ARCH%
  if errorlevel 1 exit 1
  cd %SRC_DIR%\builds\msvc\vs%VS_YEAR%\static
  msbuild libsodium.sln  /p:Configuration=Release /p:Platform=%ARCH%
  if errorlevel 1 exit 1
) else (
  cd %SRC_DIR%\builds\msvc\vs%VS_YEAR%\
  msbuild libsodium.sln /p:Configuration=DynRelease /p:Platform=%ARCH%
  if errorlevel 1 exit 1
  msbuild libsodium.sln /p:Configuration=StaticRelease /p:Platform=%ARCH%
  if errorlevel 1 exit 1
  set ARTIFACTS_DIR=%SRC_DIR%\bin\x64\Release\v140\
)

if "%VS_YEAR%" == "2010" (
  set ARTIFACTS_DIR=%SRC_DIR%\bin\x64\Release\v100\
)

move %ARTIFACTS_DIR%\dynamic\libsodium.dll %LIBRARY_BIN%
move %ARTIFACTS_DIR%\dynamic\libsodium.lib %LIBRARY_LIB%
move %ARTIFACTS_DIR%\static\libsodium.lib %LIBRARY_LIB%\libsodium_static.lib
xcopy /s /y %SRC_DIR%\src\libsodium\include\sodium %LIBRARY_INC%\
xcopy /s /y %SRC_DIR%\src\libsodium\include\sodium.h %LIBRARY_INC%\