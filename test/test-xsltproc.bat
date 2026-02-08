@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "EXE_PATH=%~1"
if "%EXE_PATH%"=="" set "EXE_PATH=%SCRIPT_DIR%xsltproc.exe"

set "TEST_DIR=%SCRIPT_DIR%resources"
set "OUT_DIR=%TEMP%\xsltproc-test-%RANDOM%"
set "RC=0"

if not exist "%EXE_PATH%" (
  echo ERROR: xsltproc not found at "%EXE_PATH%".
  set "RC=1"
  goto :Cleanup
)

if not exist "%TEST_DIR%" (
  echo ERROR: test directory not found at "%TEST_DIR%".
  set "RC=1"
  goto :Cleanup
)

mkdir "%OUT_DIR%" >nul 2>&1
if errorlevel 1 (
  echo ERROR: Failed to create temp directory "%OUT_DIR%".
  set "RC=1"
  goto :Cleanup
)

echo ==^> version output
"%EXE_PATH%" --version > "%OUT_DIR%\version.txt" 2>&1
if errorlevel 1 (
  echo ERROR: xsltproc --version failed.
  type "%OUT_DIR%\version.txt"
  set "RC=1"
  goto :Cleanup
)
findstr /c:"libxslt" "%OUT_DIR%\version.txt" >nul
if errorlevel 1 (
  echo ERROR: libxslt not found in version output.
  type "%OUT_DIR%\version.txt"
  set "RC=1"
  goto :Cleanup
)

echo ==^> identity transform
"%EXE_PATH%" --output "%OUT_DIR%\identity.out.xml" "%TEST_DIR%\identity.xsl" "%TEST_DIR%\identity.xml" >nul 2>&1
if errorlevel 1 (
  echo ERROR: identity transform failed.
  set "RC=1"
  goto :Cleanup
)
findstr /c:"<root><item>one</item><item>two</item></root>" "%OUT_DIR%\identity.out.xml" >nul
if errorlevel 1 (
  echo ERROR: identity transform output mismatch.
  type "%OUT_DIR%\identity.out.xml"
  set "RC=1"
  goto :Cleanup
)

echo ==^> string parameter
"%EXE_PATH%" --stringparam greeting Hello --output "%OUT_DIR%\param.out.txt" "%TEST_DIR%\param.xsl" "%TEST_DIR%\param.xml" >nul 2>&1
if errorlevel 1 (
  echo ERROR: string parameter test failed.
  set "RC=1"
  goto :Cleanup
)
findstr /c:"Hello" "%OUT_DIR%\param.out.txt" >nul
if errorlevel 1 (
  echo ERROR: string parameter output mismatch.
  type "%OUT_DIR%\param.out.txt"
  set "RC=1"
  goto :Cleanup
)

echo ==^> xsl:include
"%EXE_PATH%" --output "%OUT_DIR%\include.out.txt" "%TEST_DIR%\include-main.xsl" "%TEST_DIR%\include.xml" >nul 2>&1
if errorlevel 1 (
  echo ERROR: xsl:include test failed.
  set "RC=1"
  goto :Cleanup
)
findstr /c:"included-ok" "%OUT_DIR%\include.out.txt" >nul
if errorlevel 1 (
  echo ERROR: xsl:include output mismatch.
  type "%OUT_DIR%\include.out.txt"
  set "RC=1"
  goto :Cleanup
)

echo All tests passed.

:Cleanup
if exist "%OUT_DIR%" rmdir /s /q "%OUT_DIR%" >nul 2>&1
exit /b %RC%
