#!/bin/bash

### Logging

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

info() {
  printf "${GREEN}INFO:${NC} %s\n" "$1"
}

warn() {
  printf "${YELLOW}WARN:${NC} %s\n" "$1"
}

error() {
  printf "${RED}ERROR:${NC} %s\n" "$1"
}

### Utility functions

# Check if a command exists
has_command() {
  command -v "$1" &>/dev/null
}
