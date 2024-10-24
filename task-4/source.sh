#/bin/bash

alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)

input_file=""
output_file=""
shift_size=0

get_ele_index () {
  local element=$1
  shift
  local array=($@)

  for i in "${!array[@]}"; do
    if [[ "${array[$i]}" = "${element}" ]]; then
      echo $i
    fi
  done
}

if [ "$#" -eq 0 ]; then
  echo "Need arguments:
  -i|--input <input_file>
  -o|--output <output_file>
  -s|--shift <shift_size>
"
  exit 1
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    -i|--input)
      input_file="$2"
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
    *)
      echo "Unknown parameter passed: $1"
      exit 1
      ;;
  esac
done


file_contents=$(cat $input_file)

for (( i=0; i<${#file_contents}; i++ )); do
  char=${file_contents:$i:1}
  if [[ " ${alphabet[@]} " =~ " $char " ]]; then
    char_index=$(get_ele_index $char "${alphabet[@]}")
    new_index=$(( (char_index + shift_size) % ${#alphabet[@]} ))
    new_char=${alphabet[$new_index]}
    file_contents=${file_contents:0:$i}$new_char${file_contents:$((i+1))}
  fi
done

echo $file_contents > $output_file
