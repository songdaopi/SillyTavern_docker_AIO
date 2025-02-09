<p align="center">
    <h1 align="center">SillyTavern_docker_AIO</h1>
</p>
<p align="center">
    <em>🚀 SillyTavern + Clewd + YOUChat_proxy Docker 部署方案</em>
</p>
<p align="center">
    <img src="https://img.shields.io/github/license/Zhen-Bo/rplay-live-dl?style=flat&logo=opensourceinitiative&logoColor=white&color=00BFFF" alt="license">
    <img src="https://img.shields.io/github/last-commit/Zhen-Bo/SillyTavern_docker_AIO?style=flat&logo=git&logoColor=white&color=00BFFF" alt="last-commit">
    <img src="https://img.shields.io/github/languages/top/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-top-language">
    <img src="https://img.shields.io/github/languages/count/Zhen-Bo/SillyTavern_docker_AIO?style=flat&color=00BFFF" alt="repo-language-count">
</p>
<div align="center">

[English](README.md) | 简体中文

</div>

---

## 📑 目录

-   [📝 项目描述](#-项目描述)
-   [✨ 特性](#-特性)
-   [📘 使用指南](#-使用指南)
    -   [系统要求](#系统要求)
    -   [开始使用](#开始使用)
        -   [必需的文件夹结构](#必需的文件夹结构)
    -   [部署方法](#部署方法)
        -   [Shell 脚本 ⭐ 推荐 ⭐](#-方法-1使用-shell-脚本推荐)
        -   [手动部署](#方法-2手动部署)
    -   [设置 SillyTavern 反向代理](#设置-sillytavern-反向代理)
    -   [维护](#维护)
        -   [管理 Cookie](#管理-cookie)
            -   [更新 Clewd Cookie](#更新-clewd-cookie)
            -   [更新 YouChat Cookie](#更新-youchat-cookie)
        -   [查看日志](#查看日志)
        -   [停止服务](#停止服务)
    -   [配置](#配置)
        -   [Clewd 设置](#clewd-设置)
        -   [YOUChat_proxy 设置](#youchat_proxy-设置)
            -   [config.youchat.mjs](#1-configyouchatmjs)
            -   [Docker Compose 环境变量](#2-docker-compose-环境变量)
        -   [Config.yaml](#configyaml)
-   [🔧 故障排除](#-故障排除)
-   [👥 贡献](#-贡献)
-   [📜 许可证](#-许可证)
-   [🌟 致谢](#-致谢)

---

## 📝 项目描述

这是一个 Docker Compose 项目,帮助你安全地部署 `SillyTavern`、`Clewd` 和 `YOUChat_proxy`，确保 Clewd 与 YOUChat_proxy 仅在内部网络运行,同时保持 SillyTavern 的可访问性。

## ✨ 特性

这个 Docker Compose 集成使你能够:

-   使用单个命令部署 SillyTavern 和 Clewd 和 YOUChat_proxy
-   在隔离的内部网络中运行 Clewd 与 YOUChat_proxy 服务以提高安全性
-   简化配置并快速开始使用

## 📘 使用指南

### 系统要求

-   Docker 引擎
-   以下其中之一:
    -   Docker Compose 插件 (`docker compose`)
    -   Docker Compose 独立版本 (`docker-compose`)

### 开始使用

> [!IMPORTANT]  
> 首先,创建一个新的部署根文件夹。
> 你可以随意命名这个文件夹 (下文称为 `{文件夹名}`)。

### 必需的文件夹结构

> [!NOTE]
>
> -   所有目录必须在部署前创建
> -   目录名称区分大小写
> -   每个目录都有特定用途

在开始部署之前,请设置以下文件夹结构:

```
{文件夹名}/            # 根部署目录
├── plugins/              # SillyTavern 插件目录
├── config/               # 配置文件目录
├── data/                 # 用户数据和设置目录
└── extension/            # SillyTavern 扩展目录
```

### 部署方法

#### ⭐ 方法 1:使用 Shell 脚本(推荐)

1. 下载这些文件到`{文件夹名}`:

    - [config.clewd.js](config.clewd.js)
    - [config.youchat.mjs](config.youchat.mjs)

2. 修改以下文件中的设置:

    - `config.clewd.js`
    - `config.youchat.mjs`

    > **注意**  
    > 🔰 详见[配置部分](#配置)的设置详情

3. 根据你的语言选择并下载一个脚本到`{文件夹名}`:

    - [AIO_script-en_US.sh](AIO_script-en_US.sh) # 英文版本
    - [AIO_script-zh_TW.sh](AIO_script-zh_TW.sh) # 繁体中文版本

    > **注意**  
    > ⚠️ 只需下载一个与你语言偏好匹配的脚本

4. 运行 AIO 脚本并选择:

    - 部署所有服务
    - 或只部署 SillyTavern

5. 检查并配置:

    1. 检查 config.yaml 是否在 config 文件夹中生成
    2. 根据需要修改 config.yaml 设置

    > **注意**  
    > 🔰 详见[配置部分](#配置)的设置详情

6. 配置完成后:
    1. 再次运行 AIO 脚本
    2. 选择重启 SillyTavern

---

#### 方法 2:手动部署

1. 下载这些文件到`{文件夹名}`:

    - [config.clewd.js](config.clewd.js)
    - [config.youchat.mjs](config.youchat.mjs)

2. 修改以下文件中的设置:

    - `config.clewd.js`
    - `config.youchat.mjs`

    > **注意**  
    > 🔰 详见[配置部分](#配置)的设置详情

3. 使用 Docker 部署:

    ```bash
    # 使用Docker Compose独立版:
    docker-compose up -d
    # 或
    # 使用Docker Compose插件:
    docker compose up -d
    ```

4. 检查并配置:

    1. 检查 config.yaml 是否在 config 文件夹中生成
    2. 根据需要修改 config.yaml 设置

    > **注意**  
    > 🔰 详见[配置部分](#配置)的设置详情

5. 重启 SillyTavern 以应用更改:

    ```bash
    # 使用Docker Compose独立版:
    docker-compose restart SillyTavern
    # 或
    # 使用Docker Compose插件:
    docker compose restart SillyTavern
    ```

### 设置 SillyTavern 反向代理

1. Open AI 反向代理

    - 点击`API 连接`按钮
    - 选择`聊天补全来源`为`OpenAI`
    - 展开反向代理
    - 如果使用 Clewd 将 `代理服务器 URL` 设置为 `http://clewd:8444/v1`
    - 如果使用 YOUChat_proxy 将 `代理服务器 URL` 设置为 `http://youchat_proxy:8080/v1`
    - 确认 `显示外部模型（由API提供）` 为勾选状态
    - 向下滚动并点击`连接`
    - 点击`OpenAI 模型`并滚动到`External`
    - 点击你想使用的模型
    - 设置完成

2. 自定义(OpenAI 兼容)
    - 点击`API 连接`按钮
    - 选择`聊天补全来源`为`自定义 (兼容OpenAI)`
    - 如果使用 Clewd 将 `自定义端点（基础 URL）` 设置为 `http://clewd:8444/v1`
    - 如果使用 YOUChat_proxy 将 `自定义端点（基础 URL）` 设置为 `http://youchat_proxy:8080/v1`
    - 向下滚动并点击`连接`
    - 点击`可用模型`并点击你想使用的模型
    - 设置完成

### 维护

#### 管理 Cookie

##### 更新 Clewd Cookie

1. 打开`{文件夹名}/config.clewd.js`
2. 更新 Cookie/CookieArray 值
3. 重启 Clewd:
    - 通过 AIO 脚本:
        1. 运行`AIO_script`
        2. 选择`2`进入服务管理菜单
        3. 选择`2`重启 Clewd
    - 手动使用命令:
        ```bash
        # 使用 Docker Compose 插件
        docker compose restart clewd
        # 或使用旧命令
        docker-compose restart clewd
        ```

##### 更新 YouChat Cookie

1. 打开`{文件夹名}/config.youchat.mjs`
2. 更新 Cookie 值
3. 重启 YouChat proxy:
    - 通过 AIO 脚本:
        1. 运行`AIO_script`
        2. 选择`2`进入服务管理菜单
        3. 选择`3`重启 YouChat proxy
    - 手动使用命令:
        ```bash
        # 使用 Docker Compose 插件
        docker compose restart youchat_proxy
        # 或使用旧命令
        docker-compose restart youchat_proxy
        ```

#### 查看日志

##### 方法 1:使用 AIO 脚本(推荐)

1. 运行`AIO_script`
2. 选择`3`进入日志查看菜单
3. 选择要查看哪个服务的日志:
    - `1`查看 SillyTavern 日志
    - `2`查看 Clewd 日志
    - `3`查看 YouChat proxy 日志
        > **提示**  
        > 你可以用逗号组合数字来停止多个服务
        > 例如:`1,2`可以查看 SillyTavern 和 Clewd

##### 方法 2:手动命令

> [!TIP]  
> 将[service_name]替换为:SillyTavern、clewd 或 youchat_proxy

```bash
# 查看单个服务日志
docker compose logs -f [service] ([service2]...)
# 或使用旧命令
docker-compose logs -f [service] ([service2]...)

# 查看所有服务日志
docker compose logs -f
# 或使用旧命令
docker-compose logs -f
```

#### 停止服务

##### 方法 1:通过 AIO 脚本(推荐)

1. 运行`AIO_script`
2. 选择`4`进入服务管理菜单
3. 选择要停止的服务:
    - `1`停止 SillyTavern
    - `2`停止 Clewd
    - `3`停止 YouChat proxy
        > **提示**  
        > 你可以用逗号组合数字来停止多个服务
        > 例如:`1,2`可以停止 SillyTavern 和 Clewd

##### 方法 2:手动命令

> [!TIP]  
> 将[service_name]替换为:SillyTavern、clewd 或 youchat_proxy

```bash
# 停止单个服务
docker compose stop [service_name]
# 或使用旧命令
docker-compose stop [service_name]

# 停止所有服务
docker compose down
# 或使用旧命令
docker-compose down
```

### 配置

#### Clewd 设置

##### 1. config.clewd.js

1. 编辑 `Cookie` 或 `CookieArray`
2. 将 `IP` 从 `127.0.0.1` 改为 `0.0.0.0`
3. 详细设置选项请参考 [teralomaniac_clewd](https://rentry.org/teralomaniac_clewd)

#### YOUChat_proxy 设置

##### 1. config.youchat.mjs

-   编辑 `Cookie` 值

##### 2. Docker Compose 环境变量

> [!IMPORTANT]  
> USE_MANUAL_LOGIN 必须设为 false

-   除了 USE_MANUAL_LOGIN 以外的设置都可以根据需要修改
-   详细设置选项请参考 [YIWANG-sketch/YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy/blob/bypass-cf/usage.md#%E5%8F%AF%E9%80%89%E9%85%8D%E7%BD%AE--optional-configurations)

#### config.yaml

1. 编辑`port`为你想使用的端口
2. 编辑`whitelistMode`为`false`
3. 编辑`basicAuthMode`为`true`
4. 编辑`username`和`password`在`basicAuthUser`下
5. 编辑其他你想更改的设置

---

## 🔧 故障排除

开发中

---

## 👥 贡献

-   **💬 [参与讨论](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/discussions)**: 分享你的见解,提供反馈或提出问题。
-   **🐛 [报告问题](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/issues)**: 提交发现的 bug 或功能请求。
-   **💡 [提交 Pull Requests](https://github.com/Zhen-Bo/SillyTavern_docker_AIO/pulls)**: 审查开放的 PR,提交你自己的 PR。

<details closed>
<summary>贡献指南</summary>

1. **Fork 仓库**: 首先 fork 项目仓库到你的 GitHub 账户。
2. **本地克隆**: 使用 git 客户端将 fork 的仓库克隆到本地机器。
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
6. **推送到 GitHub**: 将更改推送到你 fork 的仓库。
    ```sh
    git push origin new-feature-x
    ```
7. **提交 Pull Request**: 对原项目仓库创建 PR。清晰描述更改和其动机。
8. **审查**: 一旦你的 PR 被审查并批准,它将被合并到主分支。恭喜你的贡献!

注意!请确保你的 PR:

1. 遵循现有的代码风格。
2. 使用[约定式提交消息格式](https://www.conventionalcommits.org/en/v1.0.0/)
3. 更新文档。
4. 描述所做的更改。
 </details>

### 贡献者图表

[![Contributors](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)](https://contrib.rocks/image?repo=Zhen-Bo/SillyTavern_docker_AIO)

---

## 📜 许可证

本项目采用 MIT 许可证。详情请见[LICENSE](LICENSE)文件。

---

## 🌟 致谢

-   teralomaniac: [clewd 修改版 by tera](https://github.com/teralomaniac/clewd)
-   YIWANG-sketch: [YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy)
