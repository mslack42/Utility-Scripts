# Utility Scripts Wot I've Wrote

## FastTravel
Utility script for maintaining and using commandline shortcuts

### What's the difference between the Python and the Bash script (other than the obvious)?

The Python script came first - you can (mostly) use it on both Windows and Linux (which was important to me at the time), but that comes at the cost of it being a bit hacky - pyautogui is literally typing a cd command into the terminal for you... and sometimes that causes issues.
Also, I don't much like my Python in that script.

The Bash script is a porting-over of the original Python script functionality, but minus the pyautogui schenanigans. Instead, all the hackiness in this script comes from how I'm persisting the stored shortcuts...

### Installation guidance

I alias-up these scripts so that I can use them anywhere with just a 'ft _ _'.

The Python script requires certain libraries to be installed - I remember extra steps being needed to make pyautogui happy on Linux, but I can't remember what those steps were.

The Bash script only requires you to ensure it is sourced when run (it can't change directories otherwise)
 - The Bash script even includes installation guidance! I'm learning.

Further usage:
The -g option can be called from other scripts, so for a command to open file explorer (at a given camp) you could define the following in your bash.rc...
exp () {
        xdg-open $(ft -g $1)
}

## Unknot
Utility script for pulling apart a log file where logging comes from more that one source.

Example intended use cases:
 - You have docker-compose logs, and you want logs-per-container
 - You have service logs, and want logs-per-thread

Logs are unknotted according to Regex - just identify what constitutes a 'logging line of interest' via a regular expression, and then use the script to get logs split up according to the value they match the regex with.
