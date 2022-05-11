#!/bin/bash

# Bash script that create LXC container

# Arguments given:
#   $1: template
#   $2: IPv4 address
#   $3: memory
#   $4: CPU
#   $5: password ROOT
#   $6: name of container

# Tasks:
#   1. check template name (ubuntu or debian)
#   2. check IPv4 address
#   3. check memory
#   4. check CPU
#   5. check password root
#   6. creation of the container
#   n. presentation of the container created


# Global variables
nb_arguments=6

# Task n: presentation
presentation(){
    #   $1: template
    #   $2: IPv4 address
    #   $3: memory
    #   $4: CPU
    #   $5: password ROOT
    #   $6: name of container

    echo ""
    echo "*** Container created ***"
    echo "1. template: $1"
    echo "2. IPv4 address $2"
    echo "3. memory: $3"
    echo "4. CPU: $4"
    echo "5. password ROOT: $5"
    echo "6. name of container: $6"
    echo "******************************"
    echo ""
}

# Task 1: check template name (ubuntu or debian)
check_template(){
    # $1 template name
    value_returned=1

    # Check if argument is string
    if [[ $1 =~ ^[a-z]+$ ]]; then 
        value_returned=0
    else
        echo "Error: expected a string for the template \"ubuntu\" or \"debian\""
        exit 1
    fi

    # Check if it's debian or ubuntu
    if [ "$1" = "debian" -o "$1" = "ubuntu" ]; then 
        value_returned=0
    else
        echo "Error: wrong template"
        exit 1
    fi

    return $value_returned
}

# Task 2: check IPv4 address
check_ipv4_addr(){
    # $1 ipv4 address
    value_returned=1

    #check ipv4 address dotted version
    if [[ "$1" =~ ^[0-9]{2,3}(\.[0-9]{1,3}){3}$ ]]; then
        value_returned=0
    else
        echo "Error: wrong IPv4 address"
        exit 1
    fi

    return $value_returned
}

# Task 3: check memory
check_memory(){
    # $1 memory
    value_returned=1

    # Check if there is an integer
    if [[ $1 =~ ^[0-9]{3,4}$ ]]; then 
        value_returned=0
    else
        echo "Error: expected an integer for the memory 512 - 1024 -2048"
        exit 1
    fi

    if [ $1 -eq 512 -o $1 -eq 1024 -o $1 -eq 2048 ]; then
        value_returned=0
    else
        echo "Error: expected an integer for the memory 512 - 1024 -2048"
        exit 1
    fi

    return $value_returned
}

# Task 4: check CPU
check_cpu() {
    #$1 cpu
    value_returned=1

    # Check if there is an integer
    if [[ $1 =~ ^[0-9]{1}$ ]]; then 
        value_returned=0
    else
        echo "Error: expected an integer for the cpu: 1 or 2"
        exit 1
    fi

    #Check cpu
    if [ $1 -eq 1 -o $1 -eq 2 ]; then
        value_returned=0
    else
        echo "Error: expected an integer for the cpu: 1 or 2"
        exit 1
    fi

    return $value_returned
}

# Task 5: check pasword root
check_password(){
    #$1 password
    value_returned=1

    # Check password
    if [[ $1 =~ ^[a-z]{1,10}$ ]]; then 
        value_returned=0
    else
        echo "Error: expected a string without numbers or special characters (from 1 to 10 characters)"
        exit 1
    fi

    return $value_returned
}

# Task 6: creation of the container
creation_container(){
    #   $1: template
    #   $2: IPv4 address
    #   $3: memory
    #   $4: CPU
    #   $5: password ROOT
    #   $6: name of the container

    os="none"
    memory_MiB=$3"MiB"
    bridge_network="br0"

    # Check os
    if [ $1 = "debian" ]; then
        os="debian/11"   
    else
        os="ubuntu/20.04"
    fi

    lxc init images:$os $6 -c limits.cpu=$4 -c limits.memory=$memory_MiB
    lxc config device add $6 eth1 nic name=eth1 network=$bridge_network ipv4.address=$2

    ###***### => change password root
}  


# Main function
if [ $# -eq $nb_arguments ]; then

    # Task 1: check template name (ubuntu or debian)
    check_template $1
    
    if [ $? -eq 0 ]; then
        # Task 2: check IPv4 address
        check_ipv4_addr $2
    else
        echo "Error: wrong template"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        # Task 3: check memory
        check_memory $3
    else
        echo "Error: wrong IPv4 address"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        # Task 4: check cpu
        check_cpu $4
    else
        echo "Error: wrong memory"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        # Task 5: check pasword root
        check_password $5
    else
        echo "Error: wrong cpu"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        # Task 6: creation of the container
        creation_container $1 $2 $3 $4 $5 $6
    else
        echo "Error: wrong password"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        # Task n: presentation
        presentation $1 $2 $3 $4 $5 $6
    else
        echo "Error: container not created"
        exit 1
    fi

else
    echo "Error: $nb_arguments arguments Required"
    exit 1
fi

exit 0