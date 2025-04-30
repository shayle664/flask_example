###### Start Safe Header ######
#Developed by: shay.l
#Purpose: Automate deployment of Flask web app with NGINX reverse proxy
#date: 05/04/2025
#version: 0.0.1
set -o errexit
set -o pipefail
###### End Safe Header ########

PROJECTS_DIR="/home/$SUDO_USER/projects"
PROJECT_NAME="flask_example"
TARGET_DIR="$PROJECTS_DIR/$PROJECT_NAME"

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (sudo ./deploy.sh)"
  exit 1
fi

function software_installation(){
    apt update
    apt install -y vim
    apt install -y git
    apt install -y nginx
}

function configure_nginx(){
    tee /etc/nginx/sites-available/default > /dev/null << 'EOF'
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

	nginx -t && systemctl reload nginx
}

function create_env(){
    mkdir -p "$PROJECTS_DIR"
	if [ -d "$TARGET_DIR" ]; then
		echo "❌ Project folder $TARGET_DIR already exists."
		echo "Please remove it or choose a different name."
		exit 1
	fi

	git clone https://github.com/shayle664/flask_example.git "$TARGET_DIR"
	cd "$TARGET_DIR/App"
    python3 -m venv venv
	source venv/bin/activate
    pip install -r requirements.txt
}

function start_app() {
    cd "$TARGET_DIR/App"
    source venv/bin/activate
    nohup gunicorn --bind 127.0.0.1:5000 app:app &
}

main() {
    software_installation
    configure_nginx
    create_env
    start_app
}

main