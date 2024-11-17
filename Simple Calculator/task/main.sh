#!/usr/bin/env bash

# Initialize the history file
history_file="operation_history.txt"
echo "Welcome to the basic calculator!"
echo "Welcome to the basic calculator!" > "$history_file"

while true; do
    echo "Enter an arithmetic operation or type 'quit' to quit:"
    read input

    # Echo user input to the history file
    echo "Enter an arithmetic operation or type 'quit' to quit:" >> "$history_file"
    echo "$input" >> "$history_file"

    if [[ "$input" == "quit" ]]; then
        echo "Goodbye!"
        echo "Goodbye!" >> "$history_file"
        break
    fi

    # Regular expressions for number and operator
    num_regex='^-?[0-9]+(\.[0-9]+)?$'
    op_regex='^[-+*/^]$'

    # Split the input into components
    IFS=' ' read -r num1 operator num2 extra <<< "$input"

    # Check for invalid input (extra components or missing values)
    if [[ -n "$extra" || -z "$num1" || -z "$operator" || -z "$num2" ]]; then
        echo "Operation check failed!"
        echo "Operation check failed!" >> "$history_file"
        continue
    fi

    # Check if the numbers and the operator are valid
    if [[ "$num1" =~ $num_regex ]] && \
       [[ "$operator" =~ $op_regex ]] && \
       [[ "$num2" =~ $num_regex ]]; then

        if [[ "$operator" == "/" ]]; then
            # For division, use scale=2 to truncate to two decimal places
            result=$(echo "scale=2; $num1 $operator $num2" | bc -l 2>/dev/null)
        else
            # For other operations, use bc with high precision
            result=$(echo "$num1 $operator $num2" | bc -l 2>/dev/null)
        fi

        # Check for computation errors (e.g., division by zero)
        if [[ $? -ne 0 ]] || [[ -z "$result" ]]; then
            echo "Operation check failed!"
            echo "Operation check failed!" >> "$history_file"
            continue
        fi

        # Format the result
        if [[ "$result" == "0" ]]; then
            result="0"
        elif [[ "$operator" == "/" ]]; then
            # For division, result is already truncated to two decimal places
            :
        else
            # For other operations, remove unnecessary trailing zeros
            result=$(printf "%g" "$result")
        fi

        echo "$result"
        echo "$result" >> "$history_file"
    else
        echo "Operation check failed!"
        echo "Operation check failed!" >> "$history_file"
    fi

done