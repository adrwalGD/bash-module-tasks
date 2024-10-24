#!/bin/bash

source ./commands.sh

cleanup () {
    rm -rf ~/.my_db
}

COLOR_RESET="\033[0m"
TEST_GREEN_SQUARE="\033[42m $COLOR_RESET"
TEST_RED_SQUARE="\033[41m $COLOR_RESET"

test_create_db_1 () {
    cleanup
    ./database.sh create_db test_db
    if [ ! -d ~/.my_db/test_db ]; then
        return 1
    fi
}

test_create_db_same_name () {
    cleanup
    ./database.sh create_db test_db
    RES=$(./database.sh create_db test_db)
    if [[ $RES != "Database test_db already exists!" ]]; then
        return 1
    fi
}

test_create_table_db_not_exists () {
    cleanup
    RES=$(./database.sh create_table test_db test_table)
    if [[ $RES != "Database test_db does not exist!" ]]; then
        return 1
    fi
}

test_format_row () {
    cleanup
    row=("name" "age")
    formatted=$(format_row "${row[@]}")
    if [[ ${#formatted} != 15 ]]; then
        echo ${#formatted}
        return 1
    fi
    if [[ $formatted != "** name** age**" ]]; then
        return 1
    fi
}

test_create_table_correct () {
    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    if [ ! -e ~/.my_db/test_db/test_table ]; then
        return 1
    fi
    table_contents=$(cat ~/.my_db/test_db/test_table)
    if [[ $table_contents != "** name** age**" ]]; then
        return 1
    fi
}

test_insert_data_table_not_exists () {
    cleanup
    ./database.sh create_db test_db
    RES=$(./database.sh insert_data test_db test_table name age)
    if [[ $RES != "Table test_table does not exist in database test_db." ]]; then
        return 1
    fi
}

test_insert_data_ok () {
    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    ./database.sh insert_data test_db test_table 'olek' 21
    row1=$(cat ~/.my_db/test_db/test_table | head -n 1)
    row2=$(cat ~/.my_db/test_db/test_table | tail -n 1)
    if [[ "$row1" != "** name** age**" ]]; then
        echo "row1"
        echo "$row1"
        return 1
    fi
    if [[ "$row2" != "** olek** 21**" ]]; then
        echo "row2"
        echo "$row2"
        return 1
    fi
}

test_select_data_ok () {
    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    ./database.sh insert_data test_db test_table 'olek' 21
    ./database.sh insert_data test_db test_table 'kelo' 22
    row1=$(./database.sh select_data test_db test_table | head -n 1)
    row2=$(./database.sh select_data test_db test_table | tail -n 1)
    if [[ "$row1" != "** name** age**" ]]; then
        echo "row1"
        echo "$row1"
        return 1
    fi
    if [[ "$row2" != "** kelo** 22**" ]]; then
        echo "row2"
        echo "$row2"
        return 1
    fi
}

test_find_col_num () {
    cleanup
    table_headers="** name** age**"
    col_num=$(find_col_num "$table_headers" "age")
    if [[ $col_num != 2 ]]; then
        return 1
    fi
}

test_delete_data_ok () {
    local row
    local res
    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    ./database.sh insert_data test_db test_table 'olek' 21
    ./database.sh insert_data test_db test_table 'kelo' 22
    res=$(./database.sh delete_data test_db test_table "name=olek")
    if [[ "$res" != "Deleted 1 rows." ]]; then
        echo "$res"
        return 1
    fi
}

test_find_col_num_col_not_exists () {
    cleanup
    table_headers="** name** age**"
    col_num=$(find_col_num "$table_headers" "not_exists")
    if [[ $col_num != "Column not_exists not found." ]]; then
        echo "$col_num"
        return 1
    fi
}

test_delete_data_not_deleted () {
    local res
    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    ./database.sh insert_data test_db test_table 'olek' 21
    ./database.sh insert_data test_db test_table 'kelo' 22
    res=$(./database.sh delete_data test_db test_table "name=not_found")

    if [[ "$res" != "No rows deleted." ]]; then
        echo "$res"
        return 1
    fi
}

test_create_table_too_long () {
    local res

    cleanup
    ./database.sh create_db test_db
    res=$(./database.sh create_table test_db test_table this_column_name_is_over_39_characters_mate)
    if [ -e ~/.my_db/test_db/test_table ]; then
        return 1
    fi
    if [[ "$res" != "Maximum row length is 39 characters." ]]; then
        return 1
    fi
}

test_insert_data_too_long () {
    local res

    cleanup
    ./database.sh create_db test_db
    ./database.sh create_table test_db test_table name age
    prev_content=$(cat ~/.my_db/test_db/test_table)
    res=$(./database.sh insert_data test_db test_table wow_someone_really_has_a_long_name_way_over_39_characters_mate 21)
    new_content=$(cat ~/.my_db/test_db/test_table)
    if [[ "$res" != "Maximum row length is 39 characters." ]]; then
        return 1
    fi
    if [[ "$prev_content" != "$new_content" ]]; then
        return 1
    fi
}

tests=(
    test_create_db_1
    test_format_row
    test_create_db_same_name
    test_create_table_db_not_exists
    test_create_table_correct
    test_insert_data_table_not_exists
    test_insert_data_ok
    test_select_data_ok
    test_find_col_num
    test_delete_data_ok
    test_find_col_num_col_not_exists
    test_delete_data_not_deleted
    test_create_table_too_long
    test_insert_data_too_long
)

for test in "${tests[@]}"; do
    $test
    if [ $? -eq 0 ]; then
        echo -e "$test passed. $TEST_GREEN_SQUARE"
    else
        echo -e "$test failed. $TEST_RED_SQUARE"
    fi
done
