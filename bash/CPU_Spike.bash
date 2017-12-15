#! /bin/bash

rm PIDS 1>/dev/null 2>&1

# Use variables NUM and DURATION
NUM=4
DURATION=20


# Iterate $NUM times
for (( i=0; i<$NUM; i++ )); do
    # Put an infinite loop on each CPU
    echo $i
    ./Infinite_Loop.bash &
    echo $! >> PIDS
done

# Wait DURATION seconds then stop the loops and quit
sleep $DURATION
for i in `cat PIDS`; do echo $i; kill $i; done
