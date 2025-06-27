#!/bin/bash

# Remote Access Platform Hardening Menu

# Pre-flight check for whiptail
if ! command -v whiptail &> /dev/null; then
    echo "whiptail not found. Please install it with 'sudo apt install whiptail' and rerun this script."
    exit 1
fi

main_menu() {
    while true; do
        OPTION=$(whiptail --title "System Hardening Menu" --menu "Choose an option" 20 60 10 \
        "1" "Run all hardening scripts" \
        "2" "Select individual hardening scripts" \
        "3" "Exit" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            break
        fi

        case $OPTION in
            1)
                run_all_scripts
                ;;
            2)
                individual_scripts_menu
                ;;
            3)
                break
                ;;
        esac
    done
}

run_all_scripts() {
    whiptail --msgbox "Running all hardening scripts (not yet implemented)." 10 50
    # Placeholder for future: iterate over scripts/hardening/*.sh and run them
}

individual_scripts_menu() {
    while true; do
        SCRIPT_OPTION=$(whiptail --title "Individual Hardening Scripts" --menu "Select a script to run" 20 60 10 \
        "1" "Disable root SSH login" \
        "2" "Update and upgrade system" \
        "3" "Back to main menu" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus != 0 ]; then
            break
        fi

        case $SCRIPT_OPTION in
            1)
                whiptail --msgbox "Disable root SSH login script would run here." 10 50
                ;;
            2)
                whiptail --msgbox "Update and upgrade script would run here." 10 50
                ;;
            3)
                break
                ;;
        esac
    done
}

main_menu
