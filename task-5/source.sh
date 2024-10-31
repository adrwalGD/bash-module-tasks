#!/bin/bash

input_file=""
output_file=""
operation=""

check_op_dup () {
    if [ ! -z $operation ]; then
        echo "Only one operation can be specified."
        exit 1
    fi
}

print_help () {
    echo "Need arguments:
    -i|--input <input_file>
    -o|--output <output_file>
    -r|--reverse
    -l|--lowercase
    -v
    -s <A_WORD> <B_WORD>
    "
    exit 1
}

if [ "$#" -eq 0 ]; then
    print_help
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
        -r|--reverse)
            check_op_dup
            operation="r"
            shift
            ;;
        -l|--lowercase)
            check_op_dup
            operation="l"
            shift
            ;;
        -v)
            check_op_dup
            operation="v"
            shift
            ;;
        -s)
            check_op_dup
            if [ "$#" -lt 3 ]; then
                echo "Need two words for substitution."
                print_help
                exit 1
            fi
            operation="s"
            A_WORD="$2"
            B_WORD="$3"
            shift 3
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit 1
            ;;
    esac
done

if [ -z "$input_file" ] || [ -z "$output_file" ] || [ -z "$operation" ]; then
    print_help
    exit 1
fi


case "$operation" in
    r)
        rev "$input_file" > "$output_file"
        ;;
    l)
        cat "$input_file" | tr '[:upper:]' '[:lower:]' > "$output_file"
        ;;
    v)
        cat "$input_file" | tr 'a-zA-Z' 'A-Za-z' > "$output_file"
        ;;
    s)
        cat "$input_file" | sed "s/$A_WORD/$B_WORD/g" > "$output_file"
        ;;
esac
