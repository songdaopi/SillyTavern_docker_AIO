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
        -   [Change Clewd Cookie](#change-clewd-cookie)
        -   [Viewing Logs](#viewing-logs)
        -   [Stop Services](#stop-services)
    -   [Configuration](#configuration)
        -   [Config.js Settings](#configjs)
        -   [Config.yaml Settings](#configyaml)
-   [🔧 Troubleshooting](#-troubleshooting)
-   [👥 Contributing](#-contributing)
-   [📜 License](#-license)

---

## 📝 Description

A Docker Compose project that helps you securely deploy SillyTavern and Clewd together, ensuring Clewd runs only on internal network while keeping SillyTavern accessible.

## ✨ Features

A Docker Compose integration that enables you to:

-   Deploy both SillyTavern and Clewd with a single command
-   Run Clewd service in an isolated internal network for enhanced security
-   Simplify configuration and get started quickly

## 📘 Usage Guide

### System Requirements

-   Docker Engine
-   One of the following:
    -   Docker Compose plugin (`docker compose`)
    -   Docker Compose standalone (`docker-compose`)

### Getting Started

> **IMPORTANT**: First, create a new folder for deployment. You can name it anything you want (referred to as {folder name} below).

### Required Folder Structure

Create these subfolders inside your `{folder name}:`

-   plugins
-   config
-   data
-   extension

### Deployment Methods

#### ⭐ Option 1: Using Shell Scripts (Recommended)

1. Download `config.js` to `{folder name}`
2. Configure settings in config.js (See [Configuration Section](#configuration))
3. Download these scripts to `{folder name}`:
    - `1deploy.sh`
    - `2sillytavern_restart.sh`
    - `2clewd_restart.sh`
    - `3update_images.sh`
    - `4sillytavern_logs.sh`
    - `4clewd_logs.sh`
    - `5stop_services.sh`
4. Run `1deploy.sh`
5. Edit `config.yaml` in the `config folder` (See [Configuration Section](#configuration))
6. Run `2sillytavern_restart.sh`

---

#### Option 2: Manual Deployment

1. Download `config.js` to `{folder name}`
2. Configure settings in config.js (See [Configuration Section](#configuration))
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
    - Set `Proxy Server URL` to `http://clewd:8444/v1`
    - Ensure `Show "External" models (provided by API)` checkbox is `check`
    - Scroll down and click `Connect`
    - Click `OpenAI Model` and scroll down to `External`
    - Click the Model you want to use
    - You're good to go
2. Custom (OpenAI-compatible)
    - Click `API connections` button
    - Select `Chat Conpletion Source` to `Custom (OpenAI-compatible)`
    - Set `Custom Endpoint (Base URL)` to `http://clewd:8444/v1`
    - Scroll down and click `Connect`
    - Click `Available Models` and Click the Model you want to use
    - You're good to go

### Maintenance

##### Change Clewd cookie

1. Open `{folder name}`/config.js
2. Update Cookie/CookieArray values
3. Restart Clewd:
    - Using script: Run `2clewd_restart.sh`
    - Manually:
        ```bash
        docker-compose restart Clewd
        # or
        docker compose restart Clewd
        ```

#### Viewing Logs

Using Shell script or manual to view logs

For SillyTavern logs:

```bash
# Using script
.\4sillytavern_logs.sh

# Manually
docker-compose logs -f SillyTavern
# or
docker compose logs -f SillyTavern
```

For Clewd logs:

```bash
# Using script
.\4clewd_logs.sh

# Manually
docker-compose logs -f clewd
# or
docker compose logs -f clewd
```

#### Stop services

Using Shell script or manual to view logs

```bash
# Using script
.\5stop_services.sh

# Manually
docker-compose down
# or
docker compose down
```

### Configuration

#### config.js

1. Edit `Cookie` or `CookieArray`
2. Change `IP` from `127.0.0.1` to `0.0.0.0`
3. Edit other you want to change (You can refer to the following URL to modify the [teralomaniac_clewd](https://rentry.org/teralomaniac_clewd).)

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
