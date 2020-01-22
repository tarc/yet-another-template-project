@echo off
setlocal enabledelayedexpansion


set error_message=trying conan
where conan > NUL 2> NUL
if NOT '%ERRORLEVEL%'=='0' goto fail


set error_message=trying cmake
where cmake > NUL 2> NUL
if NOT '%ERRORLEVEL%'=='0' goto fail


if NOT "%1"=="" (
	set build_type=%1
) else (
	set build_type=Debug
)


set script_dir=%~dp0

set gen_dir=%script_dir%Multi\

if EXIST %gen_dir% (
	set error_message="rmdir /s/q %gen_dir%"
	rmdir /s/q %gen_dir%
	if NOT '!ERRORLEVEL!'=='0' goto fail
)


set error_message="mkdir %gen_dir%"
mkdir %gen_dir%
if NOT '!ERRORLEVEL!'=='0' goto fail

pushd %gen_dir%


set error_message="conan install .. -g cmake_multi"

conan install .. -g cmake_multi -s build_type=Release -s compiler.runtime=MT --build=missing
if NOT '%ERRORLEVEL%'=='0' goto fail 

conan install .. -g cmake_multi -s build_type=Debug -s compiler.runtime=MTd --build=missing
if NOT '%ERRORLEVEL%'=='0' goto fail 


set generator=Visual Studio 15 2017 Win64

set error_message="cmake -G "%generator%" .."
cmake -G "%generator%" ..

if NOT '%ERRORLEVEL%'=='0' goto fail 


:success
	exit /b 0


:fail
	echo Something wrong during %error_message%
	exit /b 1