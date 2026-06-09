@echo off
setlocal enabledelayedexpansion

echo Processing ReShade preset...

:: Check if a file was dragged and dropped onto the batch script
if "%~1"=="" (
    echo Error: Please drag and drop your ReShade .ini file onto this .bat file.
    pause
    exit /b
)

set "source_file=%~1"
set "temp_file=%~dpn1_cleaned%~x1"

:: Clear temp file if it already exists
if exist "!temp_file!" del "!temp_file!"

:: Process the file line by line
for /f "delims=" %%a in ('findstr /n "^" "%source_file%"') do (
    set "line=%%a"
    :: Strip the line number prefix added by findstr to preserve empty lines safely
    set "line=!line:*:=!"
    
    if defined line (
        :: Check for specific key toggle lines and exclude them
        echo(!line! | findstr /R /C:"^KeyAmbientLight@AmbientLight\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyBloomAndLensFlares@Bloom\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyCA@ChromaticAberration\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyEmphasize@Emphasize\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyFilmGrain@FGFXEnergyConservativeFilmGrain\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyFilmGrain@FilmGrain\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyMatsoDOF@DOF\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyTechnicolor2@Technicolor2\.fx=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^KeyTiltShift@TiltShift\.fx=" >nul && set "skip=1"
        
        :: Also filter specific structural toggle lines inside [SuperDepth3D.fx]
        echo(!line! | findstr /R /C:"^Cursor_Toggle_Button_Selection=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^Toggle_Cursor=" >nul && set "skip=1"
        echo(!line! | findstr /R /C:"^Toggle_On_Boundary=" >nul && set "skip=1"

        if not defined skip (
            echo(!line!>>"!temp_file!"
        ) else (
            set "skip="
        )
    ) else (
        :: Preserve empty lines
        echo(>>"!temp_file!"
    )
)

echo Done! Output saved as:
echo "%temp_file%"
pause