# Suggestions


### Project
- folder name format needs to uniformed : all need to be created in same manner

### README
- Colorful, which is good
- Major suggestions like permissions, need to be emphesized and seen with priority: __'... run it with sudo because it modifies system ...'__

### Deploy Script
- Include permission in git : run `chmod +x deploy.sh` and it will keep the permissions
- We've talked about EOF/EOL and to use tmpl file
- `sudo` -  either use or don't use but be persistence
- Why install python packages if you have `requirements.txt` file ? or why to clone the project
- Is running `gunicorn` part of creating the env ?

### App
- why use `__main__` if you are running the app with gunicorn ?
