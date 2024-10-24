#!/bin/bash

debug=false
operation=""
numbers=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    -d|--debug)
      debug=true
      shift
      ;;
    -o|--operation)
      case "$2" in
        \+|-|\*|%)
          operation="$2"
          shift 2
          ;;
        *)
          echo "Invalid operation: $2"
          exit 1
          ;;
      esac
      ;;
    -n|--numbers)
      shift
      while [[ $1 =~ ^-?[0-9]+$ ]]; do
        numbers+=("$1")
        shift
      done
      ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
done

if [ "$debug" = true ]; then
  echo "User: $USER"
  echo "Script: $0"
  echo "Operation: $operation"
  echo "Numbers: " "${numbers[@]}"
fi

while [ "${#numbers[@]}" -gt 1 ]; do
  result=$(( ${numbers[0]} $operation ${numbers[1]} ))
  numbers=("$result" "${numbers[@]:2}")
done

echo "${numbers[@]}"
