#!/usr/bin/env bash
# Environment Variable Shamer - Because guessing is for carnival games

# Configuration file where shameful documentation lives
CONFIG_FILE=".env.shamer"

# Colors for maximum shame visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if config exists - if not, we can't shame anyone yet
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}SHAME!${NC} No .env.shamer file found. You're not even trying!"
    echo "Create one with: echo 'VAR_NAME=Description of what this does' >> .env.shamer"
    exit 1
fi

# Function to shame undocumented variables
shame_variable() {
    local var_name="$1"
    echo -e "${RED}SHAME!${NC} Variable ${YELLOW}$var_name${NC} is undocumented!"
    echo "  Your teammates are currently guessing if this is:"
    echo "  • A database password"
    echo "  • Your favorite color"
    echo "  • The meaning of life"
    echo "  • All of the above"
    echo ""
}

# Function to praise documented variables
praise_variable() {
    local var_name="$1"
    local description="$2"
    echo -e "${GREEN}GOOD HUMAN!${NC} ${YELLOW}$var_name${NC}: $description"
}

# Main shaming logic
main() {
    echo "=== ENVIRONMENT VARIABLE SHAMER ==="
    echo "Checking if you've been a good developer..."
    echo ""
    
    # Get all environment variables (excluding shell internals)
    env_vars=$(env | grep -E '^[A-Z_]+=' | cut -d= -f1 | sort)
    
    # Read documented variables from config
    declare -A documented_vars
    while IFS='=' read -r var desc; do
        documented_vars["$var"]="$desc"
    done < "$CONFIG_FILE"
    
    shame_count=0
    praise_count=0
    
    # Check each environment variable
    for var in $env_vars; do
        if [[ -n "${documented_vars[$var]}" ]]; then
            praise_variable "$var" "${documented_vars[$var]}"
            ((praise_count++))
        else
            shame_variable "$var"
            ((shame_count++))
        fi
    done
    
    echo "=== SHAME SUMMARY ==="
    echo "Documented: $praise_count"
    echo -e "Undocumented: ${RED}$shame_count${NC}"
    echo ""
    
    if [[ $shame_count -gt 0 ]]; then
        echo -e "${RED}Your teammates are crying.${NC} Add missing vars to $CONFIG_FILE"
        echo "Format: VARIABLE_NAME=What this actually does"
        exit 1
    else
        echo -e "${GREEN}No shame today! You may continue coding.${NC}"
    fi
}

# Run the shame train
main "$@"
