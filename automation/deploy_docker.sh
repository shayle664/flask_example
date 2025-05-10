###### Start Safe Header ######
#Developed by: shay.l
#Purpose: Automate deployment of Flask app + NGINX using Docker Compose
#date: 10/05/2025
#version: 0.0.1
set -o errexit
set -o pipefail
###### End Safe Header ########

PROJECTS_DIR="/home/$SUDO_USER/projects"
PROJECT_NAME="flask_example_docker"
TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (sudo ./deploy_docker.sh)"
  exit 1
fi

function install_docker() {
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
    else
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com | bash
        echo "Docker installed successfully."
    fi
}

function generate_ssl_cert() {
    SSL_DIR="$TARGET_DIR/automation/ssl"

    echo "Generating self-signed SSL certificate..."

    mkdir -p "$SSL_DIR"

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$SSL_DIR/selfsigned.key" \
        -out "$SSL_DIR/selfsigned.crt" \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

    echo "SSL certificate generated at $SSL_DIR"
}

function clone_project() {
    mkdir -p "$PROJECTS_DIR"
    if [ -d "$TARGET_DIR" ]; then
        echo "❌ Project folder $TARGET_DIR already exists."
        echo "Please remove it or choose a different name."
        exit 1
    fi
    echo "Cloning project..."
    git clone https://github.com/shayle664/flask_example.git "$TARGET_DIR"
}

function start_docker_compose() {
    echo "Starting Docker Compose..."
    cd "$TARGET_DIR"
    docker compose up -d --build
    echo "App is running at http://localhost"
}

main() {
    install_docker
    clone_project
    generate_ssl_cert
    start_docker_compose
}

main

