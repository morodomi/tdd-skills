#!/bin/bash

#######################################
# ClaudeSkills MCP Servers Installer
#
# Installs MCP servers for ClaudeSkills TDD workflow:
# - Git MCP
# - Filesystem MCP
# - GitHub MCP
#######################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#######################################
# Print colored message
# Arguments:
#   $1 - Color (RED, GREEN, YELLOW, BLUE)
#   $2 - Message
#######################################
print_message() {
    local color=$1
    local message=$2
    echo -e "${!color}${message}${NC}"
}

#######################################
# Check if command exists
# Arguments:
#   $1 - Command name
# Returns:
#   0 if exists, 1 otherwise
#######################################
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

#######################################
# Check environment prerequisites
#######################################
check_environment() {
    print_message BLUE "=== Checking environment prerequisites ==="

    local all_ok=true

    # Check Node.js
    if command_exists node; then
        local node_version=$(node --version)
        print_message GREEN "✓ Node.js: $node_version"
    else
        print_message RED "✗ Node.js is not installed"
        print_message YELLOW "  Install: brew install node"
        all_ok=false
    fi

    # Check npm
    if command_exists npm; then
        local npm_version=$(npm --version)
        print_message GREEN "✓ npm: v$npm_version"
    else
        print_message RED "✗ npm is not installed"
        print_message YELLOW "  Install: brew install node"
        all_ok=false
    fi

    # Check claude command
    if command_exists claude; then
        local claude_version=$(claude --version 2>&1 | head -1 || echo "unknown")
        print_message GREEN "✓ Claude Code: $claude_version"
    else
        print_message RED "✗ Claude Code is not installed"
        print_message YELLOW "  Install from: https://claude.ai/download"
        all_ok=false
    fi

    if [ "$all_ok" = false ]; then
        print_message RED "\nError: Missing required dependencies"
        print_message YELLOW "Please install the missing software and try again"
        exit 1
    fi

    echo ""
}

#######################################
# Check if MCP server is already installed
# Arguments:
#   $1 - Server name
# Returns:
#   0 if installed, 1 otherwise
#######################################
is_mcp_installed() {
    local server_name=$1
    claude mcp list 2>/dev/null | grep -q "^${server_name} "
}

#######################################
# Install Git MCP server
#######################################
install_git_mcp() {
    local server_name="git"

    if is_mcp_installed "$server_name"; then
        print_message YELLOW "⊙ Git MCP is already installed (skipped)"
        return 0
    fi

    print_message BLUE "Installing Git MCP..."

    if claude mcp add --transport stdio git -- npx -y @modelcontextprotocol/server-git; then
        print_message GREEN "✓ Git MCP installed successfully"
    else
        print_message RED "✗ Failed to install Git MCP"
        return 1
    fi
}

#######################################
# Install Filesystem MCP server
#######################################
install_filesystem_mcp() {
    local server_name="filesystem"

    if is_mcp_installed "$server_name"; then
        print_message YELLOW "⊙ Filesystem MCP is already installed (skipped)"
        return 0
    fi

    print_message BLUE "Installing Filesystem MCP..."

    if claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem; then
        print_message GREEN "✓ Filesystem MCP installed successfully"
    else
        print_message RED "✗ Failed to install Filesystem MCP"
        return 1
    fi
}

#######################################
# Install GitHub MCP server
#######################################
install_github_mcp() {
    local server_name="github"

    if is_mcp_installed "$server_name"; then
        print_message YELLOW "⊙ GitHub MCP is already installed (skipped)"
        return 0
    fi

    print_message BLUE "Installing GitHub MCP..."

    # Check if GITHUB_TOKEN is set
    if [ -z "$GITHUB_TOKEN" ]; then
        print_message YELLOW "⚠ GITHUB_TOKEN environment variable is not set"
        print_message YELLOW "  GitHub MCP will be installed but may not work without the token"
        print_message YELLOW "  See docs/MCP_INSTALLATION.md for setup instructions"
    fi

    if claude mcp add --transport stdio github --env GITHUB_TOKEN="${GITHUB_TOKEN:-}" -- npx -y @modelcontextprotocol/server-github; then
        print_message GREEN "✓ GitHub MCP installed successfully"
    else
        print_message RED "✗ Failed to install GitHub MCP"
        return 1
    fi
}

#######################################
# Verify installation
#######################################
verify_installation() {
    print_message BLUE "\n=== Verifying installation ==="

    echo ""
    print_message BLUE "Installed MCP servers:"
    claude mcp list
    echo ""

    local all_installed=true

    # Check Git MCP
    if is_mcp_installed "git"; then
        print_message GREEN "✓ Git MCP: Installed"
    else
        print_message RED "✗ Git MCP: Not found"
        all_installed=false
    fi

    # Check Filesystem MCP
    if is_mcp_installed "filesystem"; then
        print_message GREEN "✓ Filesystem MCP: Installed"
    else
        print_message RED "✗ Filesystem MCP: Not found"
        all_installed=false
    fi

    # Check GitHub MCP
    if is_mcp_installed "github"; then
        print_message GREEN "✓ GitHub MCP: Installed"
    else
        print_message YELLOW "⊙ GitHub MCP: Not found (optional)"
    fi

    echo ""

    if [ "$all_installed" = false ]; then
        print_message RED "Installation incomplete. Please check the errors above."
        return 1
    else
        print_message GREEN "Installation completed successfully!"
        return 0
    fi
}

#######################################
# Main function
#######################################
main() {
    print_message GREEN "╔════════════════════════════════════════╗"
    print_message GREEN "║  ClaudeSkills MCP Servers Installer  ║"
    print_message GREEN "╚════════════════════════════════════════╝"
    echo ""

    # Check environment
    check_environment

    # Install MCP servers
    print_message BLUE "=== Installing MCP servers ==="
    echo ""

    install_git_mcp
    install_filesystem_mcp
    install_github_mcp

    echo ""

    # Verify installation
    verify_installation

    # Final message
    echo ""
    print_message GREEN "════════════════════════════════════════"
    print_message GREEN "Installation complete!"
    print_message GREEN "════════════════════════════════════════"
    echo ""
    print_message BLUE "Next steps:"
    print_message BLUE "1. Verify: claude mcp list"
    print_message BLUE "2. For GitHub MCP setup: see docs/MCP_INSTALLATION.md"
    print_message BLUE "3. Start using ClaudeSkills TDD workflow!"
    echo ""
}

# Run main function
main "$@"
