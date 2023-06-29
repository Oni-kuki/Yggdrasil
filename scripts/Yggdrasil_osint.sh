#!/bin/bash

apt update -y

apt install python3-pip git -y

if [ -d /home/kali/ ]; then
    echo "the directory exists"
else
    mkdir /home/kali/
fi

apt install sublist3r -y
apt install emailharvester -y
apt install sherlock -y

pip3 install holehe
pip3 install ignorant 
pip3 install toutatis 
pip3 install sterra 
pip3 install ghunt 
pip3 install gitfive 
pip3 install h8mail 
pip3 install instaloader 
pip3 install maigret 


# RelationsFB
cd /home/kali/ && git clone https://github.com/Eriys/RelationsFB.git && cd RelationsFB/ && pip3 install -r requirements.txt && mv main.py RelationFB.py

# BlackBird
cd /home/kali/ && git clone https://github.com/p1ngul1n0/blackbird && cd blackbird && pip3 install -r requirements.txt

# nexfil
cd /home/kali/ && git clone https://github.com/thewhiteh4t/nexfil.git && cd nexfil && pip3 install -r requirements.txt 

# o365chk
cd /home/kali/ && git clone https://github.com/nixintel/o365chk && cd o365chk && pip3 install -r requirements.txt

# gvision
cd /home/kali/ && git clone https://github.com/GONZOsint/gvision && cd gvision && pip3 install -r requirements.txt && chmod +x gvision.py

# trape
cd /home/kali/ && git clone https://github.com/jofpin/trape.git && cd trape && pip3 install flask-socketio -y && chmod +x trape.py

# kalitorify
cd /home/kali/ && git clone https://github.com/brainfucksec/kalitorify && apt-get install tor curl -y && cd /home/kali/kalitorify && make install && chmod +x kalitorify.sh

#nexfil config
cd /home/kali/ 
echo -e '#!/bin/bash \ncd /home/kali/nexfil/ \npython3 "nexfil.py" "$@"' > nexfil.sh
chmod +x nexfil.sh
ln -s /home/kali/nexfil.sh /usr/local/bin/nexfil

#RelationFB config
echo -e '#!/bin/bash \ncd /home/kali/RelationsFB/ \npython3 "RelationFB.py" "$@"' > RelationFB.sh
chmod +x RelationFB.sh
ln -s /home/kali/RelationFB.sh /usr/local/bin/RelationFB

#Gvision config
echo -e '#!/bin/bash \ncd /home/kali/gvision/ \nstreamlit run "gvision.py" "$@"' > gvision.sh
chmod +x gvision.sh
ln -s /home/kali/gvision.sh /usr/local/bin/gvision

#trape config 
echo -e '#!/bin/bash \ncd /home/kali/trape/ \npython3 "trape.py" "$@"' > trape.sh
chmod +x trape.sh
ln -s /home/kali/trape.sh /usr/local/bin/trape

#blackbird config
echo -e '#!/bin/bash \ncd /home/kali/blackbird/ \npython3 "blackbird.py" "$@"' > blackbird.sh
chmod +x blackbird.sh
ln -s /home/kali/blackbird.sh /usr/local/bin/blackbird

#o365ch config
echo -e '#!/bin/bash \ncd /home/kali/o365chk/ \npython3 "o365chk.py" "$@"' > o365chk.sh
chmod +x o365chk.sh
ln -s /home/kali/o365chk.sh /usr/local/bin/o365chk
