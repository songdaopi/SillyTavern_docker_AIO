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
        -   [Shell 脚本 ⭐ 推荐 ⭐](#-方法1使用shell脚本推荐)
        -   [手动部署](#方法2手动部署)
    -   [设置 SillyTavern 反向代理](#设置sillytavern反向代理)
    -   [维护](#维护)
        -   [更改 Clewd Cookie](#更改clewd-cookie)
        -   [查看日志](#查看日志)
        -   [停止服务](#停止服务)
    -   [配置](#配置)
        -   [clewd 设置](#clewd-配置)
        -   [YOUChat_proxy 设置](#youchat_proxy-配置)
        -   [Config.yaml 设置](#configyaml)
-   [🔧 故障排除](#-故障排除)
-   [👥 贡献](#-贡献)
-   [📜 许可证](#-许可证)
-   [🌟 致谢](#-致谢)

---

## 📝 项目描述

这是一个 Docker Compose 项目,帮助你安全地部署 `SillyTavern`、`Clewd` 和 `YOUChat_proxy`，确保 Clewd 与 YOUChat_proxy 仅在内部网络运行,同时保持 SillyTavern 的可访问性。

## ✨ 特性

这个 Docker Compose 集成使你能够:

-   使用单个命令部署 SillyTavern 和 Clewd
-   在隔离的内部网络中运行 Clew 与 YOUChat_proxy 服务以提高安全性
-   简化配置并快速开始使用

## 📘 使用指南

### 系统要求

-   Docker 引擎
-   以下其中之一:
    -   Docker Compose 插件 (`docker compose`)
    -   Docker Compose 独立版本 (`docker-compose`)

### 开始使用

> **重要**:首先,创建一个新文件夹用于部署。你可以随意命名(下文称为{文件夹名})。

### 必需的文件夹结构

在你的`{文件夹名}`中创建这些子文件夹:

-   plugins
-   config
-   data
-   extension

### 部署方法

#### ⭐ 方法 1:使用 Shell 脚本(推荐)

1. 下载 `config.clewd.js` 和 `config.youchat.mjs` 到`{文件夹名}`
2. 配置 `config.clewd.js` 和 `config.youchat.mjs` 中的设置(参见[配置](#配置))
3. 下载这些脚本到`{文件夹名}`:
    - [1deploy.sh](1deploy.sh)
    - [2sillytavern_restart.sh](2sillytavern_restart.sh)
    - [2clewd_restart.sh](2clewd_restart.sh)
    - [2youchat_restart.sh](2youchat_restart.sh)
    - [3update_images.sh](3update_images.sh)
    - [4sillytavern_logs.sh]([4sillytavern_logs.sh)
    - [4clewd_logs.sh](4clewd_logs.sh)
    - [4youchat_logs.sh](4youchat_logs.sh)
    - [5stop_services.sh](5stop_services.sh)
4. 运行`1deploy.sh`
5. 编辑`config`文件夹中的`config.yaml`(参见[配置](#配置))
6. 运行`2sillytavern_restart.sh`

---

#### 方法 2:手动部署

1. 下载 `config.clewd.js` and `config.youchat.mjs` 到`{文件夹名}`
2. 配置 `config.clewd.js` and `config.youchat.mjs` 中的设置(参见[配置](#配置))
3. 使用 Docker 部署:

    ```bash
    # 使用Docker Compose独立版:
    docker-compose up -d
    # 或
    # 使用Docker Compose插件:
    docker compose up -d
    ```

4. 编辑 config 文件夹中的`config.yaml`(参见[配置](#配置))
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

##### 更改 Clewd cookie

1. 打开`{文件夹名}`/config.clewd.js
2. 更新 Cookie/CookieArray 值
3. 重启 Clewd:
    - 使用脚本:运行`2clewd_restart.sh`
    - 手动:
        ```bash
        docker-compose restart Clewd
        # 或
        docker compose restart Clewd
        ```

##### 更改 You cookie

1. 打开`{文件夹名}`/config.youchat.mjs
2. 更新 Cookie 值
3. 重启 YOUChat_proxy:
    - 使用脚本:运行`2youchat_restart.sh`
    - 手动:
        ```bash
        docker-compose restart youchat_proxy
        # 或
        docker compose restart youchat_proxy
        ```

#### 查看日志

使用 Shell 脚本或手动查看日志

查看 SillyTavern 日志:

```bash
# 使用脚本
.\4sillytavern_logs.sh

# 手动
docker-compose logs -f SillyTavern
# 或
docker compose logs -f SillyTavern
```

查看 Clewd 日志:

```bash
# 使用脚本
.\4clewd_logs.sh

# 手动
docker-compose logs -f clewd
# 或
docker compose logs -f clewd
```

查看 YOUChat_proxy 日志:

```bash
# 使用脚本
.\4youchat_logs.sh

# 手动
docker-compose logs -f youchat_proxy
# 或
docker compose logs -f youchat_proxy
```

#### 停止服务

使用 Shell 脚本或手动停止服务

```bash
# 使用脚本
.\5stop_services.sh

# 手动
docker-compose down
# 或
docker compose down
```

### 配置

#### Clewd 配置

##### 1. config.clewd.js

1. 编辑 `Cookie` 或是 `CookieArray`
2. 将 `IP` 从 `127.0.0.1` 改为 `0.0.0.0`
3. 详细设定选项请参考 [teralomaniac_clewd](https://rentry.org/teralomaniac_clewd)

#### YOUChat_proxy 配置

##### 1. config.youchat.mjs

-   Edit `Cookie` value

##### 2. Docker Compose 环境变数

> [!IMPORTANT]
> USE_MANUAL_LOGIN 必须设为 false

-   除了 USE_MANUAL_LOGIN 以外的设定都可以依需求调整
-   详细设定选项请参考 [YIWANG-sketch/YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy/blob/bypass-cf/usage.md#%E5%8F%AF%E9%80%89%E9%85%8D%E7%BD%AE--optional-configurations)

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

## 本项目采用 MIT 许可证。详情请见[LICENSE](LICENSE)文件。

## 🌟 致谢

-   teralomaniac: [clewd 修改版 by tera](https://github.com/teralomaniac/clewd)
-   YIWANG-sketch: [YOUChat_Proxy](https://github.com/YIWANG-sketch/YOUChat_Proxy)
