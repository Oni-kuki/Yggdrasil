#!/bin/bash

echo "Every jump begins with a small step..."
sleep 3s

# loading Bar
show_progress() {
    local progress_char="/-\|"
    local i=0

    while true; do
        i=$(( (i+1) % 4 ))
        printf "\r${progress_char:$i:1} $1 "
        sleep 0.1
    done
}

# execute script with the loading bar
execute_script_with_progress() {
    local script_path=$1
    local step_name=$2

    echo "$step_name..."
    
    # execution of the screen on backgroudn
    "$script_path" &
    
    # Save ID
    local script_pid=$!

    # progress bar in backgroudn
    show_progress "$step_name" &

    # waiting the ending of execution
    wait $script_pid

    # stopping the progress bar with SIGTERM
    kill $! &>/dev/null

    # wipe the progress bar
    printf "\r$step_name... Done.                  \n"

    # check the error 
    if [ $? -ne 0 ]; then
        echo "$step_name failed."
        exit 1
    fi
}


chmod o-rwx ./Yggdrasil -R
chmod g-rwx ./Yggdrasil -R
# Docker-install
chmod 700 ./install/docker-install.sh
execute_script_with_progress ./install/docker-install.sh "docker-install"

# Gvisor-install
chmod 700 ./install/gvisor-install.sh
execute_script_with_progress ./install/gvisor-install.sh "gvisor-install"

# giving authorization yggdrasil.sh
chmod 100 ./Yggdrasil.sh

# Succes
echo "Success..."
echo "Good luck for your work ! you have just made a first step !"
