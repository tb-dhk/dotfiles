#!/bin/bash

# Get the current date
today=$(date +%Y-%m-%d)
year=$(date +%Y)

# School term settings
start_of_year="01-01"
term_lengths=(10 10 10 8)
holidays=(1 4 1) # Lengths in weeks

# Function to calculate school term
calculate_term() {
    start_of_school_year=$(date -d "$year-01-01 + $(($(date -d "$year-01-01" +%u) % 7)) days" +%Y-%m-%d)
    
    if [[ "$today" < "$start_of_school_year" ]]; then
        start_of_school_year=$(date -d "$year-01-01 - 1 year" +%Y-%m-%d)
    fi
    
    current_day=$start_of_school_year
    term=1
    
    while [[ $term -le 4 ]]; do
        term_end=$(date -d "$current_day + $((term_lengths[term-1] * 7)) days" +%Y-%m-%d)
        
        if [[ "$today" < "$term_end" ]]; then
            week_number=$(( ($(date -d "$today" +%s) - $(date -d "$current_day" +%s)) / 86400 / 7 + 1 ))
            day_of_week=$(date -d "$today" +%A)
            echo "term $term  week $week_number  $day_of_week"
            return
        else
            if [[ $term -lt 4 ]]; then
                current_day=$(date -d "$term_end + $((holidays[term-1] * 7)) days" +%Y-%m-%d)
            fi
            ((term++))
        fi
    done
    
    day_of_week=$(date -d "$today" +%A)
    echo "holiday after term 4  $day_of_week"
}

calculate_term | tr '[:upper:]' '[:lower:]'

