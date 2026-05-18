#!/bin/bash

function help(){
        echo "Usage: $0 <log file>"
}

function top_ten_ip(){
	echo "Top 10 IPs:"
    	awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -10
    	echo
}

function requests_per_day(){
	echo "Requests per day:"
    	awk '{print $4}' "$log_file" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | sort -nr
    	echo
}

function count_status_codes(){
 	echo "Count by HTTP Status Codes:"
    	awk '{print $9}' "$log_file" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr
    	echo
}

log_file=$1

if [[ $# -ne 1 ]]; then
        echo "Please give only one argument"
        help
        exit 1
fi

if [[ ! -f "$log_file" ]]; then
        echo "The file '$log_file' doesn't exist"
        help
        exit 1
fi

if [[ "$log_file" != *.log ]]; then
    echo "Warning: The file does not have .log extension."
    echo "Proceeding anyway..."
fi

PS3="Choose an option: "

select choice in \
    "Top 10 IP Requests" \
    "Requests per Day" \
    "Count by HTTP Status Code" \
    "Exit"
do
    case $REPLY in
        1)
            top_ten_ip
            ;;
        2)
            requests_per_day
            ;;
        3)
            count_status_codes
            ;;
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done
