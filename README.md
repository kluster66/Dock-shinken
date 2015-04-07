# Dock-shinken
a dockerized version of shinken


Build:
docker build -t kluster/dock-shinken .

Create:
docker create -t -i -p 7767:7767 --dns 127.0.0.1 -v /home/philippe/dock-shinken/params:/home/shinken/params --name dock_shinken kluster/dock-shinken

Run
docker start dock_shinken 
