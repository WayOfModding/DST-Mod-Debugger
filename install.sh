#!/bin/sh

path_mainfunctions="../../data/scripts/mainfunctions.lua"
path_DisplayError="scripts/DisplayError.lua"
path_backup="scripts/mainfunctions.lua"

function update {
    # backup
    cp $path_mainfunctions $path_backup

    # append DisplayError.lua to mainfunctions.lua
    cat $path_DisplayError >> $path_mainfunctions

    # touch $path_backup to make it newer than
    # modified file $path_mainfunctions
    touch $path_backup
}

if [ -f $path_backup ]; then
    # check if $path_mainfunctions is newer
    alias stat='stat --format=%Y'
    # retrieve Last-Modified Timestamp of mainfunctions.lua
    lmt_mainfunctions=`stat $path_mainfunctions`
    # retrieve Last-Modified Timestamp of backup file
    lmt_backup=`stat $path_backup`
    if [ $lmt_mainfunctions -gt $lmt_backup ]; then
        # mainfunctions.lua is newer
        # backup, append and touch
        update
    fi
else
    update
fi
