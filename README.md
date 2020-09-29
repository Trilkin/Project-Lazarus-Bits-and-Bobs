# Project Lazarus Bits and Bobs
Some smaller utilities for the Project Lazarus EQ1 server.

## SetupLaz.bat

![Screenshot of SetupLaz.bat](https://i.imgur.com/XQAhgL8.jpg)

### A Batch script to simplify installation and updating of Project Lazarus

This will not work on any other emu server. Maybe one day I'll write a proper launcher in a proper language.

#### Features

* Completely simplifies the downloading and installation process. This is the ONLY file you need to download and play.

#### Requirements

* Windows 7 or better
* Fingers


#### Usage

To download and use, download the latest release from https://github.com/Trilkin/Project-Lazarus-Bits-and-Bobs/releases/tag/v1.0

Unzip the contents of this file into whatever folder you'd like. The zip includes the three utilities you need (listed in the release page) as well as the script and its readme. 

This is all you need. You should never need to manually download anything else. The script will take care of the rest. Just run SetupLaz.bat and follow the instructions.

#### Caveats

It's written in CMD Batch. It isn't the most robust thing in the world, but for what it's intended to do, it doesn't really need to be.

#### Notes For The Paranoid

The file in the release zip is SetupLaz.bat (along with the necessary utilities.) This file is also available in Scripts/Reference in case you'd like to download the utilities yourself. This file should never change.

DownloadLaz.bat is what SetupLaz.bat is downloading and is the main script. This file will change as new files are introduced. It is best to let SetupLaz.bat just download it for you, but if you'd prefer, you can download the utilities yourself and just use DownloadLaz.bat.

## CreateLazBatches.bat

![Screenshot of CreateLazBatches](https://i.imgur.com/VQSbnhf.jpg)

### A Batch script to automate creation of autologin scripts for multiple groups in EQ1.

This is written for Project Lazarus specifically, but can theoretically be adapted to work on any server as long as you use MQ2AutoLogin.

#### Features

* No additional runtimes needed! Written entirely in CMD Batch.
* Allows full editting of team and account information from a single script, removing the need to edit multiple files.
* Runs on any version of Windows all the way down to Windows 2000 if you're so inclined.

#### Requirements

* MQ2 with MQ2AutoLogin
* Fingers


#### Usage

To download and use click Code above, and then download zip file. Unzip the script to wherever you'd like.

Backup your existing MQ2AutoLogin.ini. This script overwrites it.

The script will prompt you for information. It is important you follow the instructions exactly (such as the trailing \ at the end of the folder names) or things won't work. The script is GENERALLY good about preventing you from accidentally breaking anything. Due to being written for CMD Batch, though, it's extremely easy to **intentionally** break it.

Upon finishing the script, it will generate a folder full of files. The Play Laz folder holds all of the goodies. When the script is finished, feel free to copy this folder wherever you'd like and run Play Laz.bat to play. The script will also generate files in the root folder: SavedLazVars and - if this is a subsequent run - SavedLazVars.bak. 

SavedLazVars holds all of the information you input, allowing you to do quick edits just by running the script again. The backup file is generated on subsequent runs just in case.

#### Caveats

It's written in CMD Batch. It isn't the most robust thing in the world, but for what it's intended to do, it doesn't really need to be.

Passwords are shown and saved in plain text. MQ2AutoLogin.ini also stores your passwords in plain text, so it's something of a wash. As of right now, the script still requires you input a password, but if there's enough request for it, I can change to allow for blank passwords. For now, the current behavior is preferred.
