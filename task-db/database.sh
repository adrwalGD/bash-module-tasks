#!/bin/bash

source ./commands.sh

if [[ $1 =~ ^(-h|--help)$ ]]; then
    print_help
fi

if [[ ! $1 =~ ^(create_db|create_table|insert_data|select_data|delete_data)$ ]]; then
    echo "Invalid operation: $1"
    print_help
    exit 1
fi

operation=$1
shift

case "$operation" in
    create_db)
        db_name="$1"
        create_db "$db_name"
        exit 0
        ;;
    create_table)
        db_name="$1"
        table_name="$2"
        check_db_exists "$db_name"
        insert_data "$@"
        ;;
    insert_data)
        db_name="$1"
        table_name="$2"
        check_db_exists "$db_name"
        check_table_exists "$db_name" "$table_name"
        insert_data "$@"
        ;;
    select_data)
        db_name="$1"
        table_name="$2"
        check_db_exists "$db_name"
        check_table_exists "$db_name" "$table_name"
        select_data "$@"
        ;;
    delete_data)
        db_name="$1"
        table_name="$2"
        check_db_exists "$db_name"
        check_table_exists "$db_name" "$table_name"
        delete_data "$@"
        ;;
esac
