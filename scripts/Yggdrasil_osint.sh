#! /bin/bash
apt update
apt install python3-pip git -y
if [ -d /home/kali/ ];then
        echo "the directory exist"
else    
        mkdir /home/kali/
fi

apt install Sublist3r emailharvester sherlock -y
pip3 install holehe ignorant toutatis sterra ghunt gitfive h8mail instaloader maigret 

#RelationsFB
cd /home/kali/ && git clone https://github.com/Eriys/RelationsFB.git && cd RelationsFB/ && pip3 install -r requirements.txt
#BlackBird
cd /home/kali/ && git clone https://github.com/p1ngul1n0/blackbird && cd blackbird && pip3 install -r requirements.txt
#nexfil
cd /home/kali/ && git clone https://github.com/thewhiteh4t/nexfil.git && cd nexfil && pip3 install -r requirements.txt
#o365chk
cd /home/kali/ && git clone https://github.com/nixintel/o365chk && cd o365chk && pip3 install -r requirements.txt
#gvision
cd /home/kali/ && git clone https://github.com/GONZOsint/gvision && cd gvision && pip3 -r install requirements.txt 
#trape
cd /home/kali/ && git clone https://github.com/jofpin/trape.git && cd trape && pip3 install flask-socketio -y ## to use it && python3 trape.py -h
#kalitorify
cd /home/kali/ && git clone https://github.com/brainfucksec/kalitorify && apt-get install tor curl -y && cd /home/kali/kalitorify && make install kalitorify.sh
#Osintgram
#cd /home/kali/ && git clone https://github.com/Datalux/Osintgram.git && cd Osintgram && apt install python3-venv -y && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt 