#!/bin/bash

# 定義 GitHub 倉庫 URL
GITHUB_REPO_URL="https://github.com/your_username/ai-agent-installer.git"

# 定義本地安裝目錄
INSTALL_DIR="$HOME/ai-agent-installer"

# 檢查 Git 是否已安裝
if ! command -v git &> /dev/null; then
    echo "錯誤：Git 未安裝。請先安裝 Git。"
    exit 1
fi

# 從 GitHub 克隆倉庫
echo "正在從 GitHub 下載 AI Agent 安裝器..."
git clone "$GITHUB_REPO_URL" "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo "錯誤：無法從 GitHub 克隆倉庫。"
    exit 1
fi

# 賦予安裝腳本執行權限
chmod +x "$INSTALL_DIR/install_ai_agent.sh"

echo "AI Agent 安裝器已成功下載到 $INSTALL_DIR"
echo "您可以執行以下命令來運行安裝程序："
echo "cd $INSTALL_DIR && ./install_ai_agent.sh"