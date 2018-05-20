#!/bin/bash

set -e

/c/Program\ Files/Oracle/VirtualBox/VBoxHeadless --version

TEST_PATTERN="win10-virtualbox" PROVIDER="virtualbox" bash ./init-test.bash
