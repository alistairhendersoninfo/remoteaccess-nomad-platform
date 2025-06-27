#!/bin/bash
# Remote Access Platform Main Menu System

while true; do
    OPTION=$(whiptail --title "Remote Access Platform" --menu "Choose an action" 20 60 15 \
    "1" "Install Everything (Hardening)" \
    "2" "Run Individual Hardening Script" \
    "15" "Preflight Disk Check" \
    "99" "Exit" 3>&1 1>&2 2>&3)

    case $OPTION in
        1)
            whiptail --msgbox "Starting full hardening installation..." 10 50

            scripts/hardening/check_virgin_install.sh
            scripts/hardening/update_upgrade.sh
            scripts/hardening/disable_root_login.sh
            scripts/hardening/configure_ufw.sh
            scripts/hardening/install_fail2ban.sh
            scripts/hardening/check_selinux.sh
            scripts/hardening/harden_ssh_config.sh
            scripts/hardening/user_account_audit.sh
            scripts/hardening/create_ninjaadmin.sh

            whiptail --msgbox "Full hardening installation completed." 10 50
            ;;

        2)
            SCRIPT_OPTION=$(whiptail --title "Individual Hardening Scripts" --menu "Select a script to run" 20 60 10 \
            "1" "Check Virgin Install" \
            "2" "Update & Upgrade System" \
            "3" "Disable Root SSH Login" \
            "4" "Configure UFW Firewall" \
            "5" "Install Fail2ban" \
            "6" "Check SELinux Status" \
            "7" "Harden SSH Configuration" \
            "8" "User Account Audit" \
            "9" "Create ninjaadmin User" \
            "10" "Back to Main Menu" 3>&1 1>&2 2>&3)

            case $SCRIPT_OPTION in
                1) scripts/hardening/check_virgin_install.sh ;;
                2) scripts/hardening/update_upgrade.sh ;;
                3) scripts/hardening/disable_root_login.sh ;;
                4) scripts/hardening/configure_ufw.sh ;;
                5) scripts/hardening/install_fail2ban.sh ;;
                6) scripts/hardening/check_selinux.sh ;;
                7) scripts/hardening/harden_ssh_config.sh ;;
                8) scripts/hardening/user_account_audit.sh ;;
                9) scripts/hardening/create_ninjaadmin.sh ;;
                10) continue ;;
            esac
            ;;

        15)
            scripts/modules/preflight_disk_check.sh
            ;;

        99)
            exit 0
            ;;
    esac
done
