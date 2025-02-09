#!/bin/bash

# Version information
VERSION="1.1"

# Get GitHub latest version
get_github_latest_version() {
    local version
    version=$(curl -s "https://api.github.com/repos/Zhen-Bo/SillyTavern_docker_AIO/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
    echo "$version"
}

# Version comparison function under VERSION variable
version_compare() {
    local version1=$1
    local version2=$2
    
    # Remove v prefix from version numbers (if exists)
    version1=${version1#v}
    version2=${version2#v}
    
    # Compare versions using awk
    if [ "$(echo -e "$version1\n$version2" | sort -V | head -n1)" = "$version1" ]; then
        if [ "$version1" != "$version2" ]; then
            return 0  # version1 is smaller
        else
            return 1  # versions are equal
        fi
    else
        return 2  # version1 is larger
    fi
}

# Format output function
format_status() {
    local service="$1"
    local status="$2"
    printf "%-14s: %s\n" "$service" "$status"
}

# Format title function
format_title() {
    local title="$1"
    local width=40
    local line=$(printf "%${width}s" | tr " " "=")
    if [ -z "$title" ]; then
        echo "$line"
    else
        echo "$line"
        if [ "$title" = "Main Menu" ]; then
            printf "%s%s%s\n" "=" "$(printf '%*s%s%*s' $(( (width-9)/2 )) '' "Main Menu" $(( (width-10)/2-1 )) '')" "="
        elif [ "$title" = "SillyTavern Docker AIO Manager" ]; then
            local spaces="    "  # Fixed 4 spaces
            printf "=%s%s%s=\n" "$spaces" "$title" "$spaces"
        else
            printf "%-${width}s\n" "$title"
        fi
        echo "$line"
    fi
}

# Check permissions and display status
check_status() {
    local show_env=$1
    clear
    format_title "SillyTavern Docker AIO Manager"
    
    local current_version="${VERSION}"
    local latest_version="$(get_github_latest_version)"
    
    version_compare "$current_version" "$latest_version"
    local compare_result=$?
    
    if [ $compare_result -eq 0 ]; then
        printf "Current: %s     Latest: %s (Update Available)\n" "${current_version}" "${latest_version}"
    else
        printf "Current: %-7s          Latest: %s\n" "${current_version}" "${latest_version}"
    fi
    
    # Only show environment status in main menu
    if [ "$show_env" = "true" ]; then
        echo
        echo "Environment Status:"
        echo "----------------------------"
        printf "%-17s: %s\n" "User Status" "$([ "$(id -u)" -eq 0 ] && echo "sudo" || echo "normal")"
        printf "%-17s: %s\n" "Docker Access" "$(docker ps >/dev/null 2>&1 && echo "OK" || echo "needs sudo")"
        compose_status="Not Installed"
        if docker compose version >/dev/null 2>&1; then
            compose_status="Plugin Ver."
        elif docker-compose --version >/dev/null 2>&1; then
            compose_status="Standalone"
        fi
        printf "%-17s: %s\n" "Compose Status" "$compose_status"
        echo "----------------------------"
    fi

    echo
    echo "Service Status:"
    echo "----------------------------"
    
    # Check service status
    services=("SillyTavern" "clewd" "youchat_proxy")
    for service in "${services[@]}"; do
        status=$(docker ps --format '{{.Status}}' --filter "name=$service" 2>/dev/null)
        if [ -n "$status" ]; then
            if [[ $status == *"Up"* ]]; then
                if [[ $status == *"healthy"* ]]; then
                    format_status "$service" "Running (Healthy)"
                elif [[ $status == *"unhealthy"* ]]; then
                    format_status "$service" "Running (Unhealthy)"
                else
                    format_status "$service" "Running"
                fi
            fi
        else
            container_exists=$(docker ps -a --format '{{.Status}}' --filter "name=$service" 2>/dev/null)
            if [ -n "$container_exists" ]; then
                if [[ $container_exists == *"Exited (0)"* ]]; then
                    format_status "$service" "Stopped"
                elif [[ $container_exists == *"Exited"* ]]; then
                    error_code=$(echo "$container_exists" | grep -o 'Exited ([0-9]\+)' | grep -o '[0-9]\+')
                    format_status "$service" "Error (Code: $error_code)"
                elif [[ $container_exists == *"Restarting"* ]]; then
                    format_status "$service" "Restarting"
                elif [[ $container_exists == *"Paused"* ]]; then
                    format_status "$service" "Paused"
                elif [[ $container_exists == *"Dead"* ]]; then
                    format_status "$service" "Dead"
                else
                    format_status "$service" "Unknown ($container_exists)"
                fi
            else
                format_status "$service" "Not Deployed"
            fi
        fi
    done
    echo "----------------------------"
    echo
}

# Check if Docker is installed
check_docker() {
    if ! docker --version > /dev/null 2>&1; then
        echo "Please install Docker first! Press any key to exit..."
        read -n 1
        exit 1
    fi
}

# Check docker compose version and execute command
run_docker_command() {
    local command=$1
    shift
    local services=("$@")
    
    if docker compose version > /dev/null 2>&1; then
        echo "Using docker compose plugin..."
        docker compose $command "${services[@]}"
    elif docker-compose --version > /dev/null 2>&1; then
        echo "Using docker-compose..."
        docker-compose $command "${services[@]}"
    else
        echo "Please install docker-compose or docker compose plugin! Press any key to exit..."
        read -n 1
        exit 1
    fi
}

# Display service menu
show_service_menu() {
    local action_message=$1
    clear
    check_status "false"
    format_title "Service Menu"
    echo "Select services to ${action_message}"
    echo "Use commas to select multiple services (e.g.: 1,2,3)"
    echo "1) SillyTavern"
    echo "2) Clewd"
    echo "3) YouChat"
    echo "a) All Services"
    echo "q) Exit"
    echo
    echo -n "Choose service: "
}

# Main menu
show_main_menu() {
    check_status "true"
    format_title "Main Menu"
    echo "1) Deploy Services"
    echo "2) Restart Services"
    echo "3) View Service Logs"
    echo "4) Close Services"
    echo "5) Update Services"
    echo "q) Exit"
    format_title ""
    echo
    echo -n "Select operation: "
}

# Process service selection
parse_service_selection() {
    local choice=$1
    local services=()
    
    choice=$(echo "$choice" | tr -d ' ')
    IFS=',' read -ra SELECTED <<< "$choice"
    for item in "${SELECTED[@]}"; do
        [ -z "$item" ] && continue
        
        case $item in
            "1") services+=("SillyTavern") ;;
            "2") services+=("clewd") ;;
            "3") services+=("youchat_proxy") ;;
            *) echo "Ignoring invalid choice: $item" ;;
        esac
    done
    
    echo "${services[@]}"
}

# Handle service operations
handle_service_action() {
    local action_message=$1
    local command=$2
    local display_message=$3
    
    show_service_menu "$action_message"
    read -r choice

    case $choice in
        "q") 
            exit 0 
            ;;
        "a") 
            echo "${display_message} all services..."
            run_docker_command "$command"
            ;;
        *)
            local services=($(parse_service_selection "$choice"))
            if [ ${#services[@]} -gt 0 ]; then
                echo "${display_message} selected services..."
                echo "Selected services: ${services[*]}"
                run_docker_command "$command" "${services[@]}"
            fi
            ;;
    esac
}

# Handle deployment
handle_deploy() {
    handle_service_action "deploy" "up -d" "Deploying"
}

# Handle restart
handle_restart() {
    handle_service_action "restart" "restart" "Restarting"
}

# Handle logs
handle_logs() {
    handle_service_action "view logs" "logs -f" "Viewing"
}

# Handle stop
handle_stop() {
    handle_service_action "stop" "down" "Stopping"
}

# Main program
main() {
    check_docker
    
    while true; do
        show_main_menu
        read -r choice
        
        case $choice in
            1)
                handle_deploy
                ;;
            2)
                handle_restart
                ;;
            3)
                handle_logs
                ;;
            4)
                handle_stop
                ;;
            5)
                echo "Updating services..."
                run_docker_command "pull"
                ;;
            q)
                clear
                echo "Thanks for using!"
                exit 0
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
        
        if [ "$choice" != "q" ]; then
            echo
            echo "Operation completed! Press any key to return to main menu..."
            read -n 1
        fi
    done
}

# Execute main program
main