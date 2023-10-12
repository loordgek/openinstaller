#!/bin/bash

#apt update
#apt dist-upgrade -y
#apt install crudini -y

# Initialize an empty array to store user selections
selected_items=()

# Function to display the multi-selection menu
show_menu() {
    clear
    echo "========== Multi-Selection Menu =========="
    echo "1. Option 1"
    echo "2. Option 2"
    echo "3. Option 3"
    echo "4. Done"
    echo "Selected Items: ${selected_items[*]}"
    echo "=========================================="
}

while true; do
    show_menu
    read -p "Enter the numbers of the items you want to select (1-3) or '4' to finish: " choices
    # Split the user's input into an array of choices
    IFS=" " read -ra choice_array <<< "$choices"
    for choice in "${choice_array[@]}"; do
        case "$choice" in
            1)
                selected_items+=("Option 1")
                ;;
            2)
                selected_items+=("Option 2")
                ;;
            3)
                selected_items+=("Option 3")
                ;;
            4)
                if [ ${#selected_items[@]} -eq 0 ]; then
                    echo "You haven't selected any items."
                else
                    echo "You selected the following items: ${selected_items[*]}"
                fi
                exit 0
                ;;
            *)
                echo "Invalid choice: $choice"
                ;;
        esac
    done
    read -p "Press Enter to continue..."
done
