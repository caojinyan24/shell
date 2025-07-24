#!/bin/bash
set -e

# 检查是否安装Homebrew，未安装则自动安装
if ! command -v brew &> /dev/null; then
    echo "=== 安装Homebrew ==="
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # 配置brew环境变量（适配zsh/bash）
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 更新Homebrew并安装基础依赖
echo "=== 安装基础依赖 ==="
brew update
brew install  git \
    zsh \
    wget \
    curl \
    openssl

# 配置oh-my-zsh
echo "=== 配置oh-my-zsh ==="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # 备份原zsh配置
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak" || true
    
    # 创建新的zsh配置
    cat <<EOT > "$HOME/.zshrc"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git golang zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh


export DEFAULT_USER=\$(whoami)
EOT

    # 安装zsh插件
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        
    # 设置zsh为默认shell
    chsh -s $(which zsh)
else
    echo "oh-my-zsh已安装，跳过"
fi

# 配置Git
echo "=== 配置Git ==="
if ! command -v git &> /dev/null; then
    brew install -y git
fi

# 提示用户配置Git信息
read -p "请输入Git用户名: " git_user
read -p "请输入Git邮箱: " git_email

git config --global user.name "$git_user"
git config --global user.email "$git_email"
git config --global core.editor "vim"
git config --global credential.helper osxkeychain  # macOS专用凭证管理
git config --global pull.rebase false  # 默认merge模式拉取

# 配置支持自定义后缀的git别名
git config --global alias.ck-new '!f() { \
    # 检查是否提供了自定义后缀参数
    if [ $# -eq 0 ]; then \
        echo "请提供自定义后缀作为参数，例如: git ck-new feature-login"; \
        return 1; \
    fi; \
    local suffix="$1"; \
    local date=$(date +%Y%m%d); \
    local username=$(git config user.name | tr " " "-"); \
    # 替换后缀中的空格为横线，确保分支名合法
    local safe_suffix=$(echo "$suffix" | tr " " "-"); \
    local branch="dev-${date}-${username}-${safe_suffix}"; \
    echo "创建分支: $branch"; \
    git checkout -b "$branch" && \
    git pull origin main; \
}; f'

echo "git 默认分支名配置为dev-{date}-{username}, 执行`git ck-new` 拉取新分支"


sh go-install-1.18.6.sh

# 安装VSCode
echo "=== 安装VSCode ==="
if ! command -v code &> /dev/null; then
    brew install --cask visual-studio-code
else
    echo "VSCode已安装，跳过"
fi

# 安装VSCode插件
echo "=== 安装VSCode插件 ==="
code --install-extension golang.go || true
code --install-extension ms-vscode-remote.remote-ssh || true
code --install-extension eamodio.gitlens || true
code --install-extension dbaeumer.vscode-eslint || true

# 安装GoLand 2025.2 EAP
sh jet-goland-install.sh 