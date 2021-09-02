#!/bin/sh

cat /proc/$$/cmdline | grep -oE "[\ -~]+" | grep -x -- -ash && echo true || echo false
