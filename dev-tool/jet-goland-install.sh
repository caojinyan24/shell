#!/bin/bash
set -e

# 检查并安装wget（如果需要）
if ! command -v wget &> /dev/null; then
    echo "=== 未检测到wget，正在安装 ==="
    if command -v brew &> /dev/null; then
        brew install wget
    else
        echo "请先安装Homebrew，或手动安装wget后再运行此脚本"
        exit 1
    fi
fi

# 定义GoLand EAP版本和下载链接
GOLAND_VERSION="2025.2 EAP"
# 注意：EAP版本链接可能会更新，如失效请从官网获取最新链接
GOLAND_URL="https://download-cdn.jetbrains.com/go/goland-252.23892.238-aarch64.dmg"
INSTALL_DIR="/Applications"
APP_NAME="GoLand 2025.2 EAP.app"

# 检查是否已安装
if [ -d "${INSTALL_DIR}/${APP_NAME}" ]; then
    echo "GoLand ${GOLAND_VERSION} 已安装，跳过安装"
    exit 0
fi

# 下载GoLand EAP
echo "=== 下载GoLand ${GOLAND_VERSION} ==="
TMP_DIR=$(mktemp -d)
wget -q "$GOLAND_URL" -O "${TMP_DIR}/goland-eap"


# 移动到应用程序目录
sudo mv "${TMP_DIR}/goland-eap" "${INSTALL_DIR}/${APP_NAME}"

# 清理临时文件
rm -rf "$TMP_DIR"

# 创建命令行快捷方式
if [ ! -L "/usr/local/bin/goland-eap" ]; then
    sudo ln -s "${INSTALL_DIR}/${APP_NAME}/Contents/MacOS/goland" /usr/local/bin/goland-eap
fi

echo "=== GoLand ${GOLAND_VERSION} 安装完成 ==="
echo "可以通过应用程序文件夹启动，或在终端中运行 'goland-eap' 命令"

