#!/bin/bash

print_help () {
    echo "Usage:
    $0 create_db <db_name>
    $0 create_table <db_name> <table_name> <col1> <col2> ...
    $0 insert_data <db_name> <table_name> <row>
    $0 select_data <db_name> <table_name>
    $0 delete_data <db_name> <table_name> <condition>
Examples:
    $0 create_db test_db
    $0 create_table test_db test_table name age
    $0 insert_data test_db test_table 'olek' 21
    $0 select_data test_db test_table
    $0 delete_data test_db test_table 'name=olek'
    "
    exit 1
}

# Create directory corresponding to the database
create_db () {
    db_name=$1

    if [ -d ~/.my_db/$db_name ]; then
        echo "Database $db_name already exists!"
        exit 1
    fi

    mkdir -p ~/.my_db/$db_name
}

format_row () {
    row=($@)
    formatted="** $(echo "$(printf '%s** ' ${row[@]})")"
    echo "${formatted% }"
}

validate_row () {
    local row

    row=$1
    if [ ${#row} -gt 39 ]; then
        echo "Maximum row length is 39 characters."
        exit 1
    fi
}

check_db_exists () {
    db_name=$1
    if [ ! -d ~/.my_db/$db_name ]; then
        echo "Database $db_name does not exist!"
        exit 1
    fi
}

check_table_exists () {
    db_name=$1
    table_name=$2
    if [ ! -e ~/.my_db/$db_name/$table_name ]; then
        echo "Table $table_name does not exist in database $db_name."
        exit 1
    fi
}

insert_data () {
    db_name=$1
    table_name=$2
    shift 2
    row=("$@")
    formatted_row=$(format_row "${row[@]}")
    validate_row "$formatted_row"
    echo "$formatted_row" >> "$HOME/.my_db/$db_name/$table_name"
}

select_data () {
    db_name=$1
    table_name=$2
    cat ~/.my_db/$db_name/$table_name
}

find_col_num () {
    col_found=false
    table_headers=$1
    unformatted_headers=$(echo "$table_headers" | sed 's/**//g')
    unformatted_headers=${unformatted_headers# }
    col_name=$2
    col_num=1
    for col in $unformatted_headers; do
        if [ $col = $col_name ]; then
            col_found=true
            break
        fi
        col_num=$((col_num+1))
    done
    if [ $col_found = false ]; then
        echo "Column $col_name not found."
        exit 1
    fi
    echo $col_num
}

delete_data () {
    db_name=$1
    table_name=$2
    condition=$3
    column=${condition%%=*}
    value=${condition##*=}

    col_num=$(find_col_num "$(head -n 1 ~/.my_db/$db_name/$table_name)" "$column")

    prev_file_size=$(wc -l ~/.my_db/$db_name/$table_name | awk '{print $1}')
    new_file=$(cat ~/.my_db/test_db/test_table | sed 's/**//g' | sed 's/^ //g' | awk "NR==1 || \$$col_num!=\"$value\"")
    echo "$new_file" > ~/.my_db/$db_name/$table_name
    new_file_size=$(wc -l ~/.my_db/$db_name/$table_name | awk '{print $1}')

    if [ $prev_file_size -eq $new_file_size ]; then
        echo "No rows deleted."
        exit 0
    fi
    echo "Deleted $(($prev_file_size - $new_file_size)) rows."
}
