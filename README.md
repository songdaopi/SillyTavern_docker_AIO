<p align="center">
    <h1 align="center">SillyTavern_docker_AIO</h1>
</p>
<p align="center">
    <em>🚀 SillyTavern + Clewd Docker Deployment Solution</em>
</p>
<p align="center">
    <img src="https://img.shields.io/github/license/Zhen-Bo/rplay-live-dl?style=flat&logo=opensourceinitiative&logoColor=white&color=00BFFF" alt="license">
    <img src="https://img.shields.io/github/last-commit/Zhen-Bo/SillyTavern_docker_AIO?style=flat&logo=git&logoColor=white&color=00BFFF" alt="last-commit">
    <img src="https://img.shields.io/github/languages/top/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-top-language">
    <img src="https://img.shields.io/github/languages/count/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-language-count">
</p>
<div align="center">

English | [简体中文](readme-zh_cn.md)

</div>

---

## 📑 Table of Contents

-   [📝 Description](#-description)
-   [✨ Features](#-features)
-   [📘 Usage Guide](#-usage-guide)
    -   [System Requirements](#system-requirements)
    -   [Getting Started](#getting-started)
        -   [Required Folder Structure](#required-folder-structure)
    -   [Deployment Methods](#deployment-methods)
        -   [Shell Scripts ⭐Recommended⭐](#-option-1-using-shell-scripts-recommended)
        -   [Manual Deployment](#option-2-manual-deployment)
    -   [Setup SillyTavern Reverse Proxy](#setup-sillytavern-reverse-proxy)
    -   [Maintenance](#maintenance)
        -   [Managing Cookies](#managing-cookies)
            -   [Updating Clewd Cookie](#updating-clewd-cookie)
            -   [Updating YouChat Cookie](#updating-youchat-cookie)
        -   [Viewing Logs](#viewing-logs)
        -   [Stop Services](#stop-services)
    -   [Configuration](#configuration)
        -   [Clewd Settings](#clewd-settings)
        -   [YOUChat_proxy Settings](#youchat_proxy-settings)
            -   [config.youchat.mjs](#1-configyouchatmjs)
            -   [Docker Compose Environment Variables](#2-docker-compose-environment-variables)
        -   [Config.yaml](#configyaml)
-   [🔧 Troubleshooting](#-troubleshooting)
-   [👥 Contributing](#-contributing)
-   [📜 License](#-license)
-   [🌟 Acknowledgement](#-acknowledgement)

---

## 📝 Description

A Docker Compose project that helps you securely deploy `SillyTavern` and `Clewd` and `YOUChat_proxy` together, ensuring Clewd and YOUChat_proxy runs only on internal network while keeping SillyTavern accessible.

## ✨ Features

A Docker Compose integration that enables you to:

-   Deploy both SillyTavern and Clewd with a single command
-   Run Clewd and YOUChat_proxy service in an isolated internal network for enhanced security
-   Simplify configuration and get started quickly

## 📘 Usage Guide

### System Requirements

-   Docker Engine
-   One of the following:
    -   Docker Compose plugin (`docker compose`)
    -   Docker Compose standalone (`docker-compose`)

### Getting Started

> [!IMPORTANT]  
> Create a new deployment root folder first.  
> You can choose any name for this folder (referenced as `{folder name}` below).

### Required Directory Structure

> [!NOTE]
>
> -   All directories must be created before deployment
> -   Directory names are case-sensitive
> -   Each directory serves a specific purpose

Before proceeding with deployment, set up the following folder structure:

```
{folder name}/            # Root deployment directory
├── plugins/              # SillyTavern plugins directory
├── config/               # Configuration files directory
├── data/                 # User data and settings directory
└── extension/            # SillyTavern extensions directory
```

### Deployment Methods

#### ⭐ Option 1: Using Shell Scripts (Recommended)

1. Download these files to `{folder name}` :

    - [config.clewd.js](config.clewd.js)
    - [config.youchat.mjs](config.youchat.mjs)

2. Modify settings in:

    - `config.clewd.js`
    - `config.youchat.mjs`

    > **Note**  
    > 💡 See [Configuration Section](#configuration) for setting details

3. Choose and download ONE script to `{folder name}` based on your language:

    - [AIO_script-en_US.sh](AIO_script-en_US.sh) # English version
    - [AIO_script-zh_TW.sh](AIO_script-zh_TW.sh) # Traditional Chinese version

    > **Note**  
    > ⚠️ Download only one script that matches your language preference

4. Run the AIO script and choose to:

    - Deploy all services
    - Or deploy SillyTavern only

5. Check and configure:

    1. Verify config.yaml is generated in config folder
    2. Modify config.yaml settings as needed

    > **Note**  
    > 💡 See [Configuration Section](#configuration) for setting details

6. After configuration:
    1. Run the AIO script again
    2. Select to restart SillyTavern

---

#### Option 2: Manual Deployment

1. Download `config.clewd.js` and `config.youchat.mjs` to`{folder name}`
2. Configure settings in `config.clewd.js` and `config.youchat.mjs` (See [Configuration Section](#configuration))
3. Deploy using Docker:

    ```bash
    # Using Docker Compose standalone:
    docker-compose up -d
    # or
    # Using Docker Compose plugin:
    docker compose up -d
    ```

4. Edit `config.yaml` in the config folder (See [Configuration Section](#configuration))
5. Restart SillyTavern to apply changes:

    ```bash
    # Using Docker Compose standalone:
    docker-compose restart SillyTavern
    # or
    # Using Docker Compose plugin:
    docker compose restart SillyTavern
    ```

### Setup SillyTavern Reverse Proxy

1. Open AI Reverse Proxy
    - Click `API connections` button
    - Select `Chat Conpletion Source` to `OpenAI`
    - Unfold Reverse Proxy
    - Set `Proxy Server URL` to `http://clewd:8444/v1` for `clewd`
    - Set `Proxy Server URL` to `http://youchat_proxy:8080/v1` for `YOUChat_proxy`
    - Ensure `Show "External" models (provided by API)` checkbox is `check`
    - Scroll down and click `Connect`
    - Click `OpenAI Model` and scroll down to `External`
    - Click the Model you want to use
    - You're good to go
2. Custom (OpenAI-compatible)
    - Click `API connections` button
    - Select `Chat Conpletion Source` to `Custom (OpenAI-compatible)`
    - Set `Custom Endpoint (Base URL)` to `http://clewd:8444/v1` for `clewd`
    - Set `Custom Endpoint (Base URL)` to `http://youchat_proxy:8080/v1` for `YOUChat_proxy`
    - Scroll down and click `Connect`
    - Click `Available Models` and Click the Model you want to use
    - You're good to go

### Maintenance

#### Managing Cookies

##### Updating Clewd Cookie

1. Open `{folder name}/config.clewd.js`
2. Update `Cookie` or `CookieArray` values
3. Restart Clewd service:
    - Via AIO script:
        1. Run `AIO_script`
        2. Select `2` to enter Service Management menu
        3. Select `2` to restart Clewd
    - Manually using commands:
        ```bash
        # Using Docker Compose plugin
        docker compose restart clewd
        # or using legacy command
        docker-compose restart clewd
        ```

##### Updating YouChat Cookie

1. Open `{folder name}/config.youchat.mjs`
2. Update `Cookie` value
3. Restart YouChat proxy service:
    - Via AIO script:
        1. Run `AIO_script`
        2. Select `2` to enter Service Management menu
        3. Select `3` to restart YouChat proxy
    - Manually using commands:
        ```bash
        # Using Docker Compose plugin
        docker compose restart youchat_proxy
        # or using legacy command
        docker-compose restart youchat_proxy
        ```

#### Viewing Logs

##### Method 1: Using AIO Script (Recommended)

1. Run `AIO_script`
2. Select `3` to enter Log Viewing menu
3. Choose which service(s) logs you want to view:
    - `1` for SillyTavern logs
    - `2` for Clewd logs
    - `3` for YouChat proxy logs
        > **Tip**  
        > You can stop multiple services by combining numbers with commas
        > Example: `1,2` to stop both SillyTavern and Clewd

##### Method 2: Manual Commands

> [!TIP]  
> Replace [service_name] with: SillyTavern, clewd, or youchat_proxy

```bash
# View single service logs
docker compose logs -f [service] ([service2]...)
# or using legacy command
docker-compose logs -f [service] ([service2]...)

# View all services logs
docker compose logs -f
# or using legacy command
docker-compose logs -f
```

#### Stopping Services

##### Method 1: Via AIO Script (Recommended)

1. Run `AIO_script`
2. Select `4` to enter Service Management menu
3. Choose which services to stop:
    - `1` to stop SillyTavern
    - `2` to stop Clewd
    - `3` to stop YouChat proxy
        > **Tip**  
        > You can stop multiple services by combining numbers with commas
        > Example: `1,2` to stop both SillyTavern and Clewd

##### Method 2: Manual Commands

> [!TIP]  
> Replace [service_name] with: SillyTavern, clewd, or youchat_proxy

```bash
# Stop single service
docker compose stop [service_name]
# or using legacy command
docker-compose stop [service_name]

# Stop all services
docker compose down
# or using legacy command
docker-compose down
```

### Configuration

#### Clewd Settings

##### 1. config.clewd.js

1. Edit `Cookie` or `CookieArray`
2. Change `IP` from `127.0.0.1` to `0.0.0.0`
3. For detailed configuration options, please refer to [teralomaniac_clewd](https://rentry.org/teralomaniac_clewd)

#### YOUChat_proxy Settings

##### 1. config.youchat.mjs

-   Edit `Cookie` value

##### 2. Docker Compose Environment Variables

> [!IMPORTANT]  
> USE_MANUAL_LOGIN Need to be set to false

-   All settings except USE_MANUAL_LOGIN can be modified as needed
-   For detailed configuration options, please refer to [YIWANG-sketch/YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy/blob/bypass-cf/usage.md#%E5%8F%AF%E9%80%89%E9%85%8D%E7%BD%AE--optional-configurations)

#### config.yaml

1. Edit `port` to which port you want to use
2. Edit `whitelistMode` to `false`
3. Edit `basicAuthMode` to `true`
4. Edit `username` and `password` under `basicAuthUser`
5. Edit other you want to change

---

## 🔧 Troubleshooting

WIP

---

## 👥 Contributing

-   **💬 [Join the Discussions](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/discussions)**: Share your insights, provide feedback, or ask questions.
-   **🐛 [Report Issues](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/issues)**: Submit bugs found or log feature requests for the `rplay-live-dl` project.
-   **💡 [Submit Pull Requests](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/pulls)**: Review open PRs, and submit your own PRs.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
    ```sh
    git clone https://github.com/${{ github.actor }}/SillyTavern_docker_AIO
    ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
    ```sh
    git checkout -b new-feature-x
    ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
    ```sh
    git commit -m 'Implemented new feature x.'
    ```
6. **Push to github**: Push the changes to your forked repository.
    ```sh
    git push origin new-feature-x
    ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!

Notice! Please ensure your PR:

1. Follows the existing code style.
2. Use [conventional commit messages format](https://www.conventionalcommits.org/en/v1.0.0/)
3. Updates documentation.
4. Describes the changes made.
 </details>

### Contributor Graph

[![Contributors](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🌟 Acknowledgement

-   teralomaniac: [clewd 修改版 by tera](https://github.com/teralomaniac/clewd)
-   YIWANG-sketch: [YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy)
