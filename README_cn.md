<p align="center">
    <h1 align="center">SillyTavern_docker_AIO</h1>
</p>
<p align="center">
    <em>🚀 SillyTavern + Clewd Docker 部署方案</em>
</p>
<p align="center">
    <img src="https://img.shields.io/github/license/Zhen-Bo/rplay-live-dl?style=flat&logo=opensourceinitiative&logoColor=white&color=00BFFF" alt="license">
    <img src="https://img.shields.io/github/last-commit/Zhen-Bo/SillyTavern_docker_AIO?style=flat&logo=git&logoColor=white&color=00BFFF" alt="last-commit">
    <img src="https://img.shields.io/github/languages/top/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-top-language">
    <img src="https://img.shields.io/github/languages/count/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-language-count">
</p>

---

## 📑 目录

- [📝 项目描述](#-项目描述)
- [✨ 特性](#-特性)
- [📘 使用指南](#-使用指南)
  - [系统要求](#系统要求)
  - [开始使用](#开始使用)
    - [必需的文件夹结构](#必需的文件夹结构)
  - [部署方法](#部署方法)
    - [Shell脚本 ⭐推荐⭐](#-方法1使用shell脚本推荐)
    - [手动部署](#方法2手动部署)
  - [设置SillyTavern反向代理](#设置sillytavern反向代理)
  - [维护](#维护)
    - [更改Clewd Cookie](#更改clewd-cookie)
    - [查看日志](#查看日志)
    - [停止服务](#停止服务)
  - [配置](#配置)
    - [Config.js设置](#configjs)
    - [Config.yaml设置](#configyaml)
- [🔧 故障排除](#-故障排除)
- [👥 贡献](#-贡献)
- [📜 许可证](#-许可证)

---

## 📝 项目描述

这是一个Docker Compose项目,帮助你安全地部署SillyTavern和Clewd,确保Clewd仅在内部网络运行,同时保持SillyTavern的可访问性。

## ✨ 特性

这个Docker Compose集成使你能够:

-   使用单个命令部署SillyTavern和Clewd
-   在隔离的内部网络中运行Clewd服务以提高安全性
-   简化配置并快速开始使用

## 📘 使用指南

### 系统要求

-   Docker引擎
-   以下其中之一:
    -   Docker Compose插件 (`docker compose`)
    -   Docker Compose独立版本 (`docker-compose`)

### 开始使用

> **重要**:首先,创建一个新文件夹用于部署。你可以随意命名(下文称为{文件夹名})。

### 必需的文件夹结构

在你的`{文件夹名}`中创建这些子文件夹:

-   plugins
-   config
-   data
-   extension

### 部署方法

#### ⭐ 方法1:使用Shell脚本(推荐)

1. 下载`config.js`到`{文件夹名}`
2. 配置config.js中的设置(参见[配置部分](#configuration))
3. 下载这些脚本到`{文件夹名}`:
    - `1deploy.sh`
    - `2sillytavern_restart.sh`
    - `2clewd_restart.sh`
    - `3update_images.sh`
    - `4sillytavern_logs.sh`
    - `4clewd_logs.sh`
    - `5stop_services.sh`
4. 运行`1deploy.sh`
5. 编辑`config`文件夹中的`config.yaml`(参见[配置部分](#configuration))
6. 运行`2sillytavern_restart.sh`

---

#### 方法2:手动部署

1. 下载`config.js`到`{文件夹名}`
2. 配置config.js中的设置(参见[配置部分](#configuration))
3. 使用Docker部署:

    ```bash
    # 使用Docker Compose独立版:
    docker-compose up -d
    # 或
    # 使用Docker Compose插件:
    docker compose up -d
    ```

4. 编辑config文件夹中的`config.yaml`(参见[配置部分](#configuration))
5. 重启SillyTavern以应用更改:

    ```bash
    # 使用Docker Compose独立版:
    docker-compose restart SillyTavern
    # 或
    # 使用Docker Compose插件:
    docker compose restart SillyTavern
    ```

### 设置SillyTavern反向代理

1. AI反向代理
    - 点击`API connections`按钮
    - 选择`Chat Completion Source`为`OpenAI`
    - 展开Reverse Proxy
    - 设置`Proxy Server URL`为`http://clewd:8444/v1`
    - 确保`Show "External" models (provided by API)`复选框被勾选
    - 向下滚动并点击`Connect`
    - 点击`OpenAI Model`并滚动到`External`
    - 点击你想使用的模型
    - 设置完成

2. 自定义(OpenAI兼容)
    - 点击`API connections`按钮
    - 选择`Chat Completion Source`为`Custom (OpenAI-compatible)`
    - 设置`Custom Endpoint (Base URL)`为`http://clewd:8444/v1`
    - 向下滚动并点击`Connect`
    - 点击`Available Models`并点击你想使用的模型
    - 设置完成

### 维护

##### 更改Clewd cookie

1. 打开`{文件夹名}`/config.js
2. 更新Cookie/CookieArray值
3. 重启Clewd:
    - 使用脚本:运行`2clewd_restart.sh`
    - 手动:
        ```bash
        docker-compose restart Clewd
        # 或
        docker compose restart Clewd
        ```

#### 查看日志

使用Shell脚本或手动查看日志

查看SillyTavern日志:

```bash
# 使用脚本
.\4sillytavern_logs.sh

# 手动
docker-compose logs -f SillyTavern
# 或
docker compose logs -f SillyTavern
```

查看Clewd日志:

```bash
# 使用脚本
.\4clewd_logs.sh

# 手动
docker-compose logs -f clewd
# 或
docker compose logs -f clewd
```

#### 停止服务

使用Shell脚本或手动停止服务

```bash
# 使用脚本
.\5stop_services.sh

# 手动
docker-compose down
# 或
docker compose down
```

### 配置

#### config.js

1. 编辑`Cookie`或`CookieArray`
2. 将`IP`从`127.0.0.1`改为`0.0.0.0`
3. 编辑其他你想更改的设置(你可以参考以下URL进行修改[teralomaniac_clewd](https://rentry.org/teralomaniac_clewd))

#### config.yaml

1. 编辑`port`为你想使用的端口
2. 编辑`whitelistMode`为`false`
3. 编辑`basicAuthMode`为`true`
4. 编辑`basicAuthUser`下的`username`和`password`
5. 编辑其他你想更改的设置

---

## 🔧 故障排除

开发中

---

## 👥 贡献

-   **💬 [参与讨论](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/discussions)**: 分享你的见解,提供反馈或提出问题。
-   **🐛 [报告问题](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/issues)**: 提交发现的bug或功能请求。
-   **💡 [提交Pull Requests](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/pulls)**: 审查开放的PR,提交你自己的PR。

<details closed>
<summary>贡献指南</summary>

1. **Fork仓库**: 首先fork项目仓库到你的GitHub账户。
2. **本地克隆**: 使用git客户端将fork的仓库克隆到本地机器。
    ```sh
    git clone https://github.com/${{ github.actor }}/SillyTavern_docker_AIO
    ```
3. **创建新分支**: 总是在新分支上工作,给它一个描述性的名称。
    ```sh
    git checkout -b new-feature-x
    ```
4. **做出更改**: 在本地开发和测试你的更改。
5. **提交更改**: 使用清晰的消息描述你的更新进行提交。
    ```sh
    git commit -m '实现了新特性x'
    ```
6. **推送到GitHub**: 将更改推送到你fork的仓库。
    ```sh
    git push origin new-feature-x
    ```
7. **提交Pull Request**: 对原项目仓库创建PR。清晰描述更改和其动机。
8. **审查**: 一旦你的PR被审查并批准,它将被合并到主分支。恭喜你的贡献!

注意!请确保你的PR:

1. 遵循现有的代码风格。
2. 使用[约定式提交消息格式](https://www.conventionalcommits.org/en/v1.0.0/)
3. 更新文档。
4. 描述所做的更改。
 </details>

### 贡献者图表

[![Contributors](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)

---

## 📜 许可证

本项目采用MIT许可证。详情请见[LICENSE](LICENSE)文件。