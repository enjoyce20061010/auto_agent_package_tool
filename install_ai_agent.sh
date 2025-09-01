#!/bin/bash

#
# AI Agent Installer - An interactive installer for various AI agents
#

# --- Colors for output ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

# --- Helper Functions ---
info() {
    echo -e "${C_BLUE}INFO:${C_RESET} $1"
}

success() {
    echo -e "${C_GREEN}SUCCESS:${C_RESET} $1"
}

warn() {
    echo -e "${C_YELLOW}WARNING:${C_RESET} $1"
}

fail() {
    echo -e "${C_RED}ERROR:${C_RESET} $1"
    exit 1
}

# --- Agent Installation Functions ---

# 1. VSCode Agent
install_vscode_agent() {
    info "The VSCode Agent is a Visual Studio Code extension source."
    info "To use it, you need to open the 'agents/vscode_agent' directory in VS Code."
    info "Once opened, press F5 to run the extension in a new Extension Development Host window."
    echo
    read -p "Press [Enter] to continue..."
}

# 2. n8n Agent
install_n8n_agent() {
    info "The n8n Agent requires copying workflow files to your n8n custom directory."
    
    DEFAULT_N8N_PATH="$HOME/.n8n/custom"
    read -p "Please enter the path to your n8n custom directory [default: $DEFAULT_N8N_PATH]: " N8N_PATH
    N8N_PATH=${N8N_PATH:-$DEFAULT_N8N_PATH}

    if [ ! -d "$N8N_PATH" ]; then
        warn "Directory $N8N_PATH does not exist."
        read -p "Do you want to create it? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$N8N_PATH"
            info "Created directory: $N8N_PATH"
        else
            fail "n8n agent installation cancelled."
        fi
    fi

    info "Copying n8n agent files to $N8N_PATH..."
    cp -r agents/n8n_agent/* "$N8N_PATH/"
    
    success "n8n Agent files copied successfully."
    info "Please restart your n8n instance to see the new agent workflow."
}

# 3. ChatGPT Agent
install_chatgpt_agent() {
    info "Installing the ChatGPT Agent..."

    # Check for Python
    if ! command -v python3 &> /dev/null; then
        fail "Python 3 is not installed. Please install Python 3 to continue."
    fi

    # Check for pip
    if ! command -v pip3 &> /dev/null; then
        fail "pip3 is not installed. Please install pip3 to continue."
    fi

    AGENT_DIR="agents/chatgpt_agent"
    VENV_DIR="$AGENT_DIR/venv"

    # Create virtual environment
    info "Creating Python virtual environment in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"

    # Activate virtual environment and install dependencies
    info "Installing dependencies from requirements.txt..."
    source "$VENV_DIR/bin/activate"
    pip3 install -r "$AGENT_DIR/requirements.txt"
    deactivate

    # Prompt for API Key
    read -p "Please enter your OpenAI API Key: " OPENAI_API_KEY
    if [ -z "$OPENAI_API_KEY" ]; then
        fail "OpenAI API Key cannot be empty. Installation cancelled."
    fi

    # Replace placeholder in the script using perl for cross-platform compatibility
    perl -i -pe "s/YOUR_OPENAI_API_KEY/$OPENAI_API_KEY/g" "$AGENT_DIR/chatgpt_agent.py"

    success "ChatGPT Agent installed successfully!"
    info "To run the agent, use the following commands:"
    echo "  cd $AGENT_DIR"
    echo "  source venv/bin/activate"
    echo "  python3 chatgpt_agent.py"
}


# --- Main Menu ---
main_menu() {
    clear
    echo "========================================"
    echo "       AI Agent Installer"
    echo "========================================"
    echo "This script will help you install various AI agents."
    echo
    echo "Select an agent to install:"
    
    PS3="Please enter your choice: "
    options=("VSCode Agent" "n8n Agent" "ChatGPT Agent" "Install All" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in
            "VSCode Agent")
                install_vscode_agent
                break
                ;;
            "n8n Agent")
                install_n8n_agent
                break
                ;;
            "ChatGPT Agent")
                install_chatgpt_agent
                break
                ;;
            "Install All")
                info "Installing all agents..."
                install_vscode_agent
                install_n8n_agent
                install_chatgpt_agent
                success "All agents have been processed."
                break
                ;;
            "Exit")
                break
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done
}

# --- Script Entry Point ---
main_menu
info "Installation script finished."