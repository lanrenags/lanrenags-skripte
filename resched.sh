#!/bin/sh

PROCESS_NAMES="srcds_linux srcds_i686 srcds_i486 srcds_amd hlds_i686 hlds_i486 hlds_amd"
for name in $PROCESS_NAMES; do
  PIDS=`pidof $name`
  for p in $PIDS; do
    chrt -f -p 98 $p
  done
done

# This is for the RT patches only, it does nothing on other kernels
PIDS=`ps ax | grep sirq-hrtimer | grep -v grep | sed -e "s/^ *//" -e "s/ .*$//"`
for p in $PIDS; do
  chrt -f -p 99 $p
done
PIDS=`ps ax | grep sirq-timer | grep -v grep | sed -e "s/^ *//" -e "s/ .*$//"`
for p in $PIDS; do
 chrt -f -p 51 $p
done
