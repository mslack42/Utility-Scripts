#! /usr/bin/python3

# Command Line utility for docker exec-ing into containers by name

import sys, os
import pyautogui
import subprocess

containerName = ''
containerId = ''

def parseArgs():
    global containerName
    if len(sys.argv) == 2:
        containerName = sys.argv[1]
    else:
        print('Expect 1 parameter - container name')

def getContainerId():
    global containerId
    global containerName
    if containerName == '':
        return
    nameFilter = 'name=' + containerName
    result = subprocess.check_output(['docker', 'ps', '-qf', nameFilter])
    ids = result.splitlines()
    if len(ids) == 1:
        containerId = ids[0].decode('utf-8')
    else:
        print('Multiple matching containers found')

def dockerExec():
    global containerId
    if containerId == '':
        return
    pyautogui.typewrite('docker exec -it ' + containerId + ' bash')
    pyautogui.typewrite(['enter'])

parseArgs()
getContainerId()
dockerExec()