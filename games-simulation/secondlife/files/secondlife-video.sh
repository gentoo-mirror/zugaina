#!/bin/sh
# This script starts SecondLife and continues to monitor the log-file. Whenever a Movie is played 
# within SL, automatically mplayer is launched with the correct URL. After the movie is played, 
# mplayer automatically shuts down.
#
# This script is published under the GNU-license, and can be modified by everyone.
#-----------------------------------------
# Marco van der Heide (aka Marcoh Larsen)
# 26-12-2006: V1.0: First version
#
# Cowboy Carnell
# 07-03-2007: V1.1: Minor "improvements"
# This version modified simply to move variations in preferences to variables rather
# than hardcoded within the script.  The original logic stays intact 100%, except for
# the edition of cleaning up any left-over /tmp/gxine.starter files, which isn't likely
# to happen anyway

# ################################
# Begin customizable params
# ################################
# The two commented versions exist for legacy purposes to match V1.0 and can be removed or used
# Note: this is the path to the executable, not the executable itself, the executable
# will be $PATH_TO_SECONDLIFE/secondlife
#PATH_TO_SECONDLIFE="/home/hawkwind/games/SecondLife_i686_1_13_3_2" 
#PATH_TO_SECONDLIFE="$HOME/games/SecondLife_i686_1_13_3_2"
PATH_TO_SECONDLIFE="/usr/share/games/secondlife"

PATH_TO_LOGS="$HOME/.secondlife/logs"

#MEDIA_PLAYER="vlc"
MEDIA_PLAYER="mplayer"

MEDIA_PID='/tmp/sl-video.starter'

TIME_TO_WAIT=2
# ################################
# End customizable params
# ################################

# If SecondLife (or starter) already is started, directly quit.
# for debugging only
if [ `ps -ef | grep secondlife | grep -v grep | grep -v tail  wc -l` -gt 2 ] ; then
#if [ `ps -ef | grep secondlife | grep -v grep | wc -l` -gt 2 ] ; then
    ps -ef | grep secondlife | grep -v grep | wc -l
    echo "Stopping ..."
    exit
fi
 
# Clear the log
> $PATH_TO_LOGS/SecondLife.saved
cat $PATH_TO_LOGS/SecondLife.log >> $PATH_TO_LOGS/SecondLife.saved
> $PATH_TO_LOGS/SecondLife.log

# Make sure the video player trigger wasn't left behind accidently
if [ -f $MEDIA_PID ]; then
    echo -e "\nMPLAYER remnants from previous run cleaned up\n" >> $PATH_TO_LOGS/SecondLife.saved
    rm -f $MEDIA_PID
fi
 
# Start SL with a nice, so mplayer will run normally.
nice -n 1 /bin/sh $PATH_TO_SECONDLIFE/secondlife &
sleep 15
 
# While SL is running, check the log-file every $TIME_TO_WAIT seconds.
while [ `ps -ef | grep do-not-directly-run-secondlife-bin | grep -v grep | wc -l` -gt 0 ] ; do
    grep "INFO: MEDIA> unable to load" $PATH_TO_LOGS/SecondLife.log | tail -1 | awk '{print $7}' > $MEDIA_PID
    if [ -s $MEDIA_PID ] ; then
        echo -e "\nMPLAYER LAUNCHED\n" >> $PATH_TO_LOGS/SecondLife.saved
        $MEDIA_PLAYER `tail -1 $MEDIA_PID` 2>&1 >> $PATH_TO_LOGS/SecondLife.saved
        rm -f $MEDIA_PID
        echo -e "\nMPLAYER LAUNCH END\n" >> $PATH_TO_LOGS/SecondLife.saved
    fi
    cat $PATH_TO_LOGS/SecondLife.log >> $PATH_TO_LOGS/SecondLife.saved
    > $PATH_TO_LOGS/SecondLife.log
    sleep $TIME_TO_WAIT
done
