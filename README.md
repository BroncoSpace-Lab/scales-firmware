# How to install the scales-leviathan-layer in the base IMX8QXP Phytec BSP to bake the custom scales-leviathan linux image

Copy the meta-scales-leviathan folder to
/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/sources

then

copy the /conf folder to /BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build
if it already exists, please replace it with this version.

Then, follow the bitbake process for the standard image provided here:
https://scales-docs.readthedocs.io/en/latest/imx_yocto_bsp/

# How to install the watchdogjetson program on the scales-jetson

We want to run the watchdogJetson program on Jetson boot, to do this we can use cron, or create a systemd service to automate the process.

### systemd service

Copy the watchdogJetson.service file to /etc/systemd/system/ using:
cp watchdogJetson.service /etc/systemd/system/

Once its copied, run vim to edit the file
vim watchdogJetson.service

Now modify the following to reflect your system directories:

User=<your_user_name_here>
Group=<your_group>
WorkingDirectory=</directory/where/your/watchdogJetson.service/file/is/located>
ExecStart=/usr/bin/python3 /directory/where/your/watchdogJetson.service/file/is/located/watchdogJetson.py

Once your service file has been modified, be sure to check that everything is where you described, and then reload your systemd service
sudo systemctl daemon-reload

Now enable the service at boot
sudo systemctl enable watchdogjetson.service

 
