@echo off
tasklist /FI "IMAGENAME eq QuickLook.exe" | find /I "QuickLook.exe" >nul
if errorlevel 1 (
	start "" "C:\Program Files\QuickLook\QuickLook.exe"
)
