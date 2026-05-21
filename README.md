# Docker OpenVPN + SSH

Ubuntu 22.04 Docker 镜像，内置 SSH 和 OpenVPN 1194 端口预留，支持公钥和密码双认证。

## 目录结构

```
docker-openvpn/
├── Dockerfile         # 镜像构建文件
├── entrypoint.sh      # 容器启动入口，运行时拉取 GitHub 公钥
└── README.md          # 本文件
```

## 构建镜像

```bash
docker build -t ubuntu-ssh .
```

## 运行容器

```bash
docker run -d --name ubuntu-ssh \
  -p 2222:22 \
  -p 1194:1194/udp \
  -e GITHUB_USER=你的GitHub用户名 \
  ubuntu-ssh
```

### 参数说明

| 参数 | 说明 |
|------|------|
| `-p 2222:22` | 将容器 SSH 端口映射到宿主机 2222 端口 |
| `-p 1194:1194/udp` | 预留 OpenVPN UDP 端口 |
| `-e GITHUB_USER` | GitHub 用户名，容器启动时自动拉取该用户的公钥 |

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `SSH_USER` | `admin` | SSH 登录用户名 |
| `SSH_PASSWORD` | `Passw0rd!` | 登录密码 |
| `GITHUB_USER` | `your_github_username` | 用于拉取公钥的 GitHub 用户名 |

## SSH 登录

### 密钥登录（推荐）

设置 `GITHUB_USER` 后，容器启动会自动从 `https://github.com/<用户名>.keys` 拉取公钥：

```bash
ssh admin@localhost -p 2222
```

### 密码登录

```bash
ssh admin@localhost -p 2222
# 密码: Passw0rd!
```

## 安全说明

- root 远程登录已禁用
- 默认使用 `admin` 用户，可通过 `sudo` 提权
- 同时支持公钥认证和密码认证
- 生产环境建议修改默认密码

## 端口

| 端口 | 协议 | 用途 |
|------|------|------|
| 22 | TCP | SSH 登录（容器内部） |
| 1194 | UDP | OpenVPN 预留端口 |
