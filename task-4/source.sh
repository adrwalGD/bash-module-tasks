#!/bin/bash

alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
alphabet_caps=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

input_file=""
output_file=""
shift_size=0
mode=""

print_help () {
    echo "Need arguments:
    -i|--input <input_file>
    -o|--output <output_file>
    -s|--shift <shift_size>
    -m|--mode [encrypt|decrypt]
"
}

if [ "$#" -eq 0 ]; then
    print_help
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -i|--input)
            input_file="$2"
            if [ ! -e $input_file ]; then
                echo "File does not exist."
                exit 1
            fi
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -s|--shift)
            shift_size="$2"
            shift 2
            ;;
        -m|--mode)
            case "$2" in
                encrypt|decrypt)
                    mode="$2"
                    shift 2
                    ;;
                *)
                    echo "Invalid mode: $2"
                    print_help
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Unknown parameter passed: $1"
            print_help
            exit 1
            ;;
    esac
done

if [ -z "$input_file" ] || [ -z "$output_file" ] || [ -z "$shift_size" ] || [ -z "$mode" ]; then
    echo "Missing arguments."
    print_help
    exit 1
fi

if [ "$mode" = "encrypt" ]; then
    lower_start_index=$(( $shift_size % ${#alphabet[@]} ))
    upper_start_index=$(( $shift_size % ${#alphabet_caps[@]} ))
    lower_start_letter=${alphabet[$lower_start_index]}
    upper_start_letter=${alphabet_caps[$upper_start_index]}
    echo $lower_start_letter
    echo $upper_start_letter
    cat $input_file | tr 'a-z' "$lower_start_letter"-za-"$lower_start_letter" | tr 'A-Z' "$upper_start_letter"-ZA-"$upper_start_letter" > $output_file
elif [ "$mode" = "decrypt" ]; then
    lower_start_index=$((( ${#alphabet[@]} - ($shift_size % ${#alphabet[@]}) ) % ${#alphabet[@]} ))
    upper_start_index=$((( ${#alphabet_caps[@]} - ($shift_size % ${#alphabet_caps[@]}) ) % ${#alphabet_caps[@]} ))
    lower_start_letter=${alphabet[$lower_start_index]}
    upper_start_letter=${alphabet_caps[$upper_start_index]}
    echo $lower_start_letter
    echo $upper_start_letter
    cat $input_file | tr 'a-z' "$lower_start_letter"-za-"$lower_start_letter" | tr 'A-Z' "$upper_start_letter"-ZA-"$upper_start_letter" > $output_file
fi
