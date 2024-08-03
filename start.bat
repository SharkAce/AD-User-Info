@echo off
mode con: cols=100 lines=30
title ActiveDirectory User Info Script
powershell -ExecutionPolicy Bypass -File "%~dp0main.ps1"
