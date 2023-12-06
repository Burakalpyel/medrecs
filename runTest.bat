@echo off
pushd %~dp0  REM Move to the script's directory

REM Run flutter test command
flutter test

popd  REM Return to the original directory
