#!/bin/bash

# 版本資訊
VERSION="1.1"

# 獲取 GitHub 最新版本
get_github_latest_version() {
    local version
    version=$(curl -s "https://api.github.com/repos/Zhen-Bo/SillyTavern_docker_AIO/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
    echo "$version"
}

# 在 VERSION 變數下方新增版本比較函數
version_compare() {
    local version1=$1
    local version2=$2
    
    # 移除版本號前的 v (如果存在)
    version1=${version1#v}
    version2=${version2#v}
    
    # 使用 awk 比較版本號
    if [ "$(echo -e "$version1\n$version2" | sort -V | head -n1)" = "$version1" ]; then
        if [ "$version1" != "$version2" ]; then
            return 0  # version1 較小
        else
            return 1  # 版本相同
        fi
    else
        return 2  # version1 較大
    fi
}

# 格式化輸出函數
format_status() {
    local service="$1"
    local status="$2"
    printf "%-14s: %s\n" "$service" "$status"
}

# 格式化標題函數
format_title() {
    local title="$1"
    local width=40
    local line=$(printf "%${width}s" | tr " " "=")
    if [ -z "$title" ]; then
        echo "$line"
    else
        echo "$line"
        if [ "$title" = "主選單" ]; then
            printf "%s%s%s\n" "=" "$(printf '%*s%s%*s' $(( (width-8)/2 )) '' "主選單" $(( (width-9)/2 )) '')" "="
        elif [ "$title" = "SillyTavern Docker AIO 管理工具" ]; then
            local spaces="   "  # 固定 4 個空格
            printf "=%s%s%s=\n" "$spaces" "$title" "$spaces"
        else
            printf "%-${width}s\n" "$title"
        fi
        echo "$line"
    fi
}

# 檢查權限和顯示狀態
check_status() {
    local show_env=$1  # 新增參數來控制是否顯示環境狀態
    clear
    format_title "SillyTavern Docker AIO 管理工具"
    
    local current_version="${VERSION}"
    local latest_version="$(get_github_latest_version)"
    
    version_compare "$current_version" "$latest_version"
    local compare_result=$?
    
    if [ $compare_result -eq 0 ]; then
        printf "當前版本: %s     最新版本: %s (可更新)\n" "${current_version}" "${latest_version}"
    else
        printf "當前版本: %-7s          最新版本: %s\n" "${current_version}" "${latest_version}"
    fi
    
    # 只在主選單顯示環境狀態
    if [ "$show_env" = "true" ]; then
        echo
        echo "環境狀態:"
        echo "----------------------------"
        # 檢查使用者權限
        printf "%-20s: %s\n" "使用者狀態" "$([ "$(id -u)" -eq 0 ] && echo "sudo" || echo "一般")"
        # 檢查 Docker 權限
        printf "%-17s: %s\n" "Docker 權限" "$(docker ps >/dev/null 2>&1 && echo "正常" || echo "需要 sudo")"
        # 檢查 Compose 狀態
        compose_status="未安裝"
        if docker compose version >/dev/null 2>&1; then
            compose_status="插件版"
        elif docker-compose --version >/dev/null 2>&1; then
            compose_status="獨立版"
        fi
        printf "%-17s: %s\n" "Compose 狀態" "$compose_status"
        echo "----------------------------"
    fi

    echo
    echo "服務狀態:"
    echo "----------------------------"
    
    # 檢查各服務狀態
    services=("SillyTavern" "clewd" "youchat_proxy")
    for service in "${services[@]}"; do
        # 獲取容器狀態
        status=$(docker ps --format '{{.Status}}' --filter "name=$service" 2>/dev/null)
        if [ -n "$status" ]; then
            if [[ $status == *"Up"* ]]; then
                if [[ $status == *"healthy"* ]]; then
                    format_status "$service" "運行中 (健康)"
                elif [[ $status == *"unhealthy"* ]]; then
                    format_status "$service" "運行中 (不健康)"
                else
                    format_status "$service" "運行中"
                fi
            fi
        else
            container_exists=$(docker ps -a --format '{{.Status}}' --filter "name=$service" 2>/dev/null)
            if [ -n "$container_exists" ]; then
                if [[ $container_exists == *"Exited (0)"* ]]; then
                    format_status "$service" "正常停止"
                elif [[ $container_exists == *"Exited"* ]]; then
                    error_code=$(echo "$container_exists" | grep -o 'Exited ([0-9]\+)' | grep -o '[0-9]\+')
                    format_status "$service" "異常停止 (錯誤碼: $error_code)"
                elif [[ $container_exists == *"Restarting"* ]]; then
                    format_status "$service" "重啟中"
                elif [[ $container_exists == *"Paused"* ]]; then
                    format_status "$service" "已暫停"
                elif [[ $container_exists == *"Dead"* ]]; then
                    format_status "$service" "已終止"
                else
                    format_status "$service" "未知狀態 ($container_exists)"
                fi
            else
                format_status "$service" "未部署"
            fi
        fi
    done
    echo "----------------------------"
    echo
}

# 檢查 Docker 是否安裝
check_docker() {
    if ! docker --version > /dev/null 2>&1; then
        echo "請先安裝 Docker! 按任意鍵退出..."
        read -n 1
        exit 1
    fi
}

# 檢查 docker compose 版本並執行命令
run_docker_command() {
    local command=$1
    shift
    local services=("$@")
    
    if docker compose version > /dev/null 2>&1; then
        echo "使用 docker compose 插件..."
        docker compose $command "${services[@]}"
    elif docker-compose --version > /dev/null 2>&1; then
        echo "使用 docker-compose..."
        docker-compose $command "${services[@]}"
    else
        echo "請安裝 docker-compose 或 docker compose 插件! 按任意鍵退出..."
        read -n 1
        exit 1
    fi
}

# 顯示服務選單
show_service_menu() {
    local action_message=$1
    clear
    check_status "false"  # 傳遞 false 表示不顯示環境狀態
    format_title "服務選單"
    echo "正在選擇要${action_message}的服務"
    echo "可使用逗號分隔同時選擇多個服務 (例如: 1,2,3)"
    echo "1) SillyTavern"
    echo "2) Clewd"
    echo "3) YouChat"
    echo "a) 所有服務"
    echo "q) 退出"
    echo
    echo -n "請選擇服務："
}

# 主選單
show_main_menu() {
    check_status "true"  # 傳遞 true 表示顯示環境狀態
    format_title "主選單"
    echo "1) 部署服務"
    echo "2) 重啟服務"
    echo "3) 查看服務日誌"
    echo "4) 關閉服務"
    echo "5) 更新服務"
    echo "q) 退出"
    format_title ""
    echo
    echo -n "請選擇操作："
}

# 處理服務選擇
parse_service_selection() {
    local choice=$1
    local services=()
    
    # 處理多重選擇，移除所有空白
    choice=$(echo "$choice" | tr -d ' ')
    IFS=',' read -ra SELECTED <<< "$choice"
    for item in "${SELECTED[@]}"; do
        # 跳過空值
        [ -z "$item" ] && continue
        
        case $item in
            "1") services+=("SillyTavern") ;;
            "2") services+=("clewd") ;;
            "3") services+=("youchat_proxy") ;;
            *) echo "忽略無效選擇: $item" ;;
        esac
    done
    
    echo "${services[@]}"
}

# 處理服務操作
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
            echo "${display_message}所有服務..."
            run_docker_command "$command"
            ;;
        *)
            local services=($(parse_service_selection "$choice"))
            if [ ${#services[@]} -gt 0 ]; then
                echo "${display_message}選定的服務..."
                echo "選定的服務: ${services[*]}"
                run_docker_command "$command" "${services[@]}"
            fi
            ;;
    esac
}
# 處理部署
handle_deploy() {
    handle_service_action "部署" "up -d" "正在部署"
}

# 處理重啟
handle_restart() {
    handle_service_action "重啟" "restart" "正在重啟"
}

# 處理日誌
handle_logs() {
    handle_service_action "查看日誌" "logs -f" "正在查看"
}

# 處理停止
handle_stop() {
    handle_service_action "停止" "down" "正在停止"
}

# 主程序
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
                echo "正在更新服務..."
                run_docker_command "pull"
                ;;
            q)
                clear
                echo "感謝使用！"
                exit 0
                ;;
            *)
                echo "無效選擇"
                ;;
        esac
        
        if [ "$choice" != "q" ]; then
            echo
            echo "操作完成！按任意鍵返回主選單..."
            read -n 1
        fi
    done
}

# 執行主程序
main