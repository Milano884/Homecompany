#!/bin/bash

# Function to perform addition
add() {
    result=$(echo "$1 + $2" | bc)
    echo "Result: $result"
}

# Function to perform subtraction
subtract() {
    result=$(echo "$1 - $2" | bc)
    echo "Result: $result"
}

# Function to perform multiplication
multiply() {
    result=$(echo "$1 * $2" | bc)
    echo "Result: $result"
}

# Function to perform division
divide() {
    if [ "$2" -eq 0 ]; then
        echo "Error: Division by zero is not allowed."
    else
        result=$(echo "scale=2; $1 / $2" | bc)
        echo "Result: $result"
    fi
}

# Main script
echo "Simple Calculator"
echo "Select operation:"
echo "1. Addition"
echo "2. Subtraction"
echo "3. Multiplication"
echo "4. Division"
read -p "Enter choice [1-4]: " choice

read -p "Enter first number: " num1
read -p "Enter second number: " num2

case $choice in
    1)
        add $num1 $num2
        ;;
    2)
        subtract $num1 $num2
        ;;
    3)
        multiply $num1 $num2
        ;;
    4)
        divide $num1 $num2
        ;;
    *)
        echo "Invalid choice."
        ;;
esac
