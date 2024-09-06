#!/bin/bash
#192.168.98.5

# Colors
PBlack='\033[30m'		# 1
PRed='\033[31m'		    # 2
PGreen='\033[32m'		# 3
POrange='\033[33m'		# 4
PBlue='\033[34m'		# 5
PPurple='\033[35m'		# 6
PCyan='\033[36m'		# 7
PGray='\033[37m'		# 8
PWhite='\e[37m'		    # 9
NC='\033[39m'


function ctrl_c(){
    printf "\n\n ${PRed}[*] Going out ...\n ${PWhite}"
    tput cnorm; exit 1
}

trap ctrl_c INT


function def_help(){
    printf "${PGreen}[*] The necesary arguments are:\n"
    printf "\t-H  : Host scanning\n"
    printf "\t-P  : Port scanning\n"
    printf "\t Example: \n"
    printf "\t$0 -H ${PCyan}10.10.10.1-254 \t ${PGreen}Active Host\n" 
    printf "\t$0 -P ${PCyan}10.10.10.10 \t ${PGreen}Active Ports ${PWhite}\n"
}

function def_validIp () {
    local  ip=$1
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255  && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

#Function hosting scanning
function scanHost (){
    local ipAddress=$1
    local range=$2
    local ipStart=$(echo "$ipAddress"| cut -d "-" -f 1| awk '{print $4}' FS=".")
    local length=${#ipAddress}
    local ipAddress=(${ipAddress::l-2})  
    printf "${PPurple}[*] ${PGreen}Host Enumeration, ${POrange}Waiting${PWhite}\n"  
    for ((i =$ipStart; i<$range+1; i++)); do
        local ip="$ipAddress.$i"
        timeout 1 bash -c "ping -c 1 $ip &>/dev/null" && printf "${PPurple} [✓] ${PBlue} $ip ${POrange} Host active ${PWhite}\n" #& #threads
        #wait
    done
}

#Function Port scanning
function scanPort (){
    local ipAddress=$1
    if def_validIp $ipAddress; then
        printf "${PPurple}[*] ${PGreen}Port Enumeration    ${PBlue}$host:\n"
        for ((port=0; port<=65535; port++)); do
            if echo "s7v7n" 2>/dev/null > /dev/tcp/"$ipAddress"/"$port"
            then
                
                printf "${PPurple} [✓] ${PBlue} $port ${POrange} Port Active\n ${PWhite}"
            fi
        done
    else
        printf "${PRed}[X] Invalid IP address\n ${PWhite}"
        def_help
        exit 1

    fi

}

#Function main
function def_main(){
    if [[ $# -ne 2 ]]; then
        printf "${PRed}[X] Error, wrong arguments ${PWhite}\n";
        def_help
        exit 1;
    else 
        if [[ $1 = "-H" ]]; then
            local ipAddress=$(echo $2| cut -d "-" -f 1)
            local ip=$(echo $2| cut -d "-" -f 2)

            if def_validIp $ipAddress; then
                scanHost $ipAddress $ip
            else 
                printf "${PRed}[X] Invalid IP address ${PWhite}\n"
                def_help
                exit 1
            fi
        fi
        ##Scan Ports
        if [[ $1 = "-P" ]]; then
            local host=$2
            scanPort $host
        fi
    fi
}

def_main $@

