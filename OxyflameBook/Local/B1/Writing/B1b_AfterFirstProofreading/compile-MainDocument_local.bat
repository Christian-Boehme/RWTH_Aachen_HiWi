@ECHO OFF

PUSHD \\%~P0

:: Run Cleanup

taskkill /F /FI "WindowTitle eq MainDocument_local.pdf - Adobe Acrobat Pro" /T
taskkill /F /FI "WindowTitle eq MainDocument_local.pdf - Adobe Acrobat Reader DC" /T

del *.log
del *.aux
del *.bbl
del *.blg
del *.out
del *.nlo
del MainDocument_local.pdf

IF EXIST MainDocument_local.tex GOTO start
GOTO fehler

:start
pdflatex MainDocument_local
biber MainDocument_local
::FOR %%a IN (MainDocument_local*.aux) DO IF NOT %%a == MainDocument_local.aux biber %%a
FOR %%i IN (1,1,2) DO pdflatex MainDocument_local

START MainDocument_local.pdf
del *.log
del *.aux
del *.bbl
del *.blg
del *.out
del *.nlo

GOTO ende

:fehler
ECHO Datei existiert nicht

pause

:ende

