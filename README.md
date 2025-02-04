# DayZServer-PI5
A complete how-to guide to build your own vanilla (and moddable) DayZ server on the Raspberry Pi 5!

Step 1. Source hardware: My hardware list for this build included an 8GB Raspberry Pi 5, iUniker PCIe M.2 HAT+ for Raspberry Pi 5, and a Corsair MP600 CORE XT 1TB PCIe Gen4 x4 NVMe M.2 SSD. The container with the server running uses 65% of the 8GB of RAM so I don't think this will work on a Pi with less RAM. Also, as smaller NVMe will work as I'm currently only using 50GB on my install.

Step 2. Install base OS on Raspberry Pi 5: For my build, I used Ubuntu Server 24.04. Install is easy as it's just a matter of flashing the OS image via Raspberry Pi Imager to the NVMe. When you are setting up the image, be sure to enable SSH so that you can log into your Pi with the specified username, password, and hostname if you aren't using a directly connected display. To SSH into the Pi after it's booted, use the following command and enter your specified password:
```console
ssh USERNAME@HOSTNAME.local
```
Step 3. Install Docker: I am assuming the reader of this section has little experience with docker so each step is spelled out.

a. Update Packages:
```console
sudo apt-get update
```
b. Install pre-requisite packages:
```console
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```
c. Add Docker gpg key:
```console
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
d. Add repository:
```console
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
e. Update packages with new repo:
```console
sudo apt-get update
```
f. Install Docker:
```console
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
g. Start Docker:
```console
sudo systemctl start docker
```
h. Enable Docker at boot:
```console
sudo systemctl enable docker
```
i. Verify installed version:
```console
docker --version
```
j. Test Docker install:
```console
docker run hello-world
```
If you see the "Hello from Docker!" message, congratulations on installing Docker!


Step 4. Pull and run my DayZ Server Docker image:
```console
docker run -i -t -d -p 2302:2302/udp -p 2303:2303/udp -p 2304:2304/udp -p 2305:2305/udp -p 8766:8766/udp -p 27016:27016/udp -v dayz-server-data:/home/ --name dayzpiserver artemisian/steamcmd-dayz:latest
```
This command starts the DayZ Server container with proper ports exposed and persistent volume named dayz-server-data mounted.
Verify the container is running with:
```console
docker ps
```
Step 5. Open a command line for the container with the following command:
```console
docker exec -it dayzpiserver /bin/bash
```
Before we start the server, you'll need to edit a couple of configuration files, both the config.ini and serverDZ.cfg file. I've included vim in this container to edit files so if you aren't familar with that editor, you may want to do some quick Google research first.

First, edit the config.ini file. The key with this file is to add your steam userid in the steamlogin=" " field, you can also swap to the experimental branch app ID if you're looking to run experimental. 
```console
vi /home/config.ini
```
Once you have input your steamlogin and made any other changes of your choice, save and close this file.

Next, we'll edit the serverDZ.cfg. The main changes needed here are to name your server in the hostname field, adding a password if desired, and adding a server description. The remaining fields are your perogative to modify. Open the file with the following command:
```console
vi /home/serverfiles/serverDZ.cfg
```
Make your changes here and save and close this file and now it's time to start the server install!

Step 5. Install and start the DayZ server.

The first step here is to update SteamCMD and install all files for the DayZ server, luckily, HaywarGG from the Steam community has created a script for free use!
In the container terminal you opened in Step 5, use the following command to update SteamCMD and install server files:
```console
bash dayzserver.sh
```
It will take a while as all of the DayZ server files are downloaded, but once it completes (ignore the line 550 error) you can run the next command to start the server:
```console
bash dayzserver.sh start
```
This will start your server and return you back to the shell prompt of the container, you can check status, restart, or stop the server with the following commands:
Check Status:
```console
bash dayzserver.sh monitor
```
Restart:
```console
bash dayzserver.sh restart
```
Stop:
```console
bash dayzserver.sh stop
```
That's it! Remember to use the command "exit" in your container shell to drop back to the main Ubuntu prompt on your Pi. Enjoy exploring your own vanilla DayZ world hosted on a Raspberry Pi! 
If you ever need to stop or start the container on your Pi, those commands follow: (server state and config files will be saved thanks to the persistent volume)
```console
docker stop dayzpiserver
```
```console
docker start dayzpiserver
```

I hope this guide inspires someone to learn a bit about docker and to become one of the few running a DayZ server on a Raspberry Pi!

