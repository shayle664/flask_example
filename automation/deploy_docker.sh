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
	echo "installing Docker"
	curl -fsSL https://get.docker.com | bash
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
    docker-compose up -d --build
    echo "App is running at http://localhost"
}

main() {
    install_docker
    clone_project
    start_docker_compose
}

main

