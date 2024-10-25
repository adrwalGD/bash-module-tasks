#!/bin/bash

fib () {
    if [ $1 -le 1 ]; then
        echo $1
    else
        echo $(( $(fib $(( $1 - 1 )) ) + $(fib $(( $1 - 2 )) ) ))
    fi
}

echo "Fibonacci sequence for 1: $(fib 1)"
echo "Fibonacci sequence for 2: $(fib 2)"
echo "Fibonacci sequence for 3: $(fib 3)"
echo "Fibonacci sequence for 4: $(fib 4)"
echo "Fibonacci sequence for 5: $(fib 5)"
echo "Fibonacci sequence for 6: $(fib 6)"
