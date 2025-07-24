#!/bin/bash
set -e

# 定义要安装的Go版本
GO_VERSION="1.18.6"
GO_TAR="go${GO_VERSION}.darwin-amd64.tar.gz"
GO_URL="https://dl.google.com/go/${GO_TAR}"
INSTALL_DIR="/usr/local"

# 检查是否已安装指定版本
if command -v go &> /dev/null; then
    INSTALLED_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    if [ "$INSTALLED_VERSION" = "$GO_VERSION" ]; then
        echo "Golang $GO_VERSION 已安装，无需重复安装"
        exit 0
    else
        echo "检测到已安装Golang $INSTALLED_VERSION，将替换为 $GO_VERSION"
        sudo rm -rf "$INSTALL_DIR/go"
    fi
fi


# 检查并安装wget
if ! command -v wget &> /dev/null; then
    echo "=== 未检测到wget，正在安装 ==="
    if command -v brew &> /dev/null; then
        brew install wget
    else
        echo "请先安装Homebrew，或手动安装wget后再运行此脚本"
        exit 1
    fi
fi
# 下载指定版本的Go
echo "=== 下载Golang $GO_VERSION ==="
wget -q "$GO_URL" -O "/tmp/${GO_TAR}"

# 解压到安装目录
echo "=== 安装Golang $GO_VERSION ==="
sudo tar -C "$INSTALL_DIR" -xzf "/tmp/${GO_TAR}"

# 清理安装文件
rm "/tmp/${GO_TAR}"

# 配置Go环境变量
echo "=== 配置Go环境变量 ==="
ZSHRC="$HOME/.zshrc"

# 移除已有的Go环境变量配置
sed -i '' '/# Go环境配置/,+2d' "$ZSHRC" 2>/dev/null || true

# 添加新的环境变量配置
cat <<EOT >> "$ZSHRC"
# Go环境配置
export GOROOT=$INSTALL_DIR/go
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOT

# 立即应用环境变量
export GOROOT="$INSTALL_DIR/go"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

# 验证安装
echo "=== 验证安装 ==="
go version

if go version | grep -q "$GO_VERSION"; then
    echo "Golang $GO_VERSION 安装成功"
    echo "请重启终端或执行 source ~/.zshrc 应用配置"
else
    echo "安装失败，请检查错误信息"
    exit 1
fi
