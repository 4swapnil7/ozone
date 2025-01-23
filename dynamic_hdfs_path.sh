#!/bin/bash

# Example inputs
part_columns=("utm" "vertical" "partition_date" "hour")
values=("utm=skyc,jhd" "vertical=home,mobility,other" "partition_date=2024-09-06" "hour=1,2,3")

# Input partition column for which we generate output
target_column="partition_date"

# Find the position of the target column in the part_columns list
target_pos=0
for i in "${!part_columns[@]}"; do
    if [[ "${part_columns[$i]}" == "$target_column" ]]; then
        target_pos=$i
        break
    fi
done

# Extract values for columns up to the target column
declare -A column_values
for value in "${values[@]}"; do
    key="${value%%=*}"
    vals="${value#*=}"
    column_values["$key"]="$vals"
done

# Recursive function to generate combinations
generate_combinations() {
    local index=$1
    local prefix=$2

    # Base case: if index reaches the target column, print the prefix
    if [[ $index -eq $target_pos ]]; then
        echo "${prefix%/}/${part_columns[$target_pos]}"
        return
    fi

    # Get the current column and its values
    local current_column="${part_columns[$index]}"
    local current_values="${column_values[$current_column]}"

    # Iterate through the values of the current column
    IFS=',' read -r -a values_array <<< "$current_values"
    for value in "${values_array[@]}"; do
        generate_combinations $((index + 1)) "$prefix$value/"
    done
}

# Start generating combinations from the leftmost column
generate_combinations 0 ""
