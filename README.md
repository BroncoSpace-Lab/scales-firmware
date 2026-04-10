# Installing `meta-scales-leviathan` and `watchdogJetson`

This guide covers:
1. Installing the `meta-scales-leviathan` layer into the base i.MX8QXP PHYTEC BSP
2. Setting up `watchdogJetson` to run automatically at boot using `systemd`

---

## Install the `meta-scales-leviathan` Layer in the Base i.MX8QXP PHYTEC BSP

To bake the custom `scales-leviathan` Linux image, copy the `meta-scales-leviathan` folder into the Yocto sources directory:

```bash
cp -r meta-scales-leviathan /BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/sources/
```

Next, copy the `conf` folder into the Yocto build directory. If a `conf` folder already exists there, replace it with this version:

```bash
cp -r conf /BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/
```

Then follow the standard BitBake process for the image using the instructions here:

https://scales-docs.readthedocs.io/en/latest/imx_yocto_bsp/

---

## Install the `watchdogJetson` Program on the Scales Jetson

To run the `watchdogJetson` program automatically at Jetson boot, create a `systemd` service.

### Create the `systemd` Service File

Copy the contents of the `watchdogJetson.service` file into a text file and save it as:

```text
watchdogJetson.service
```

Then copy the service file into `/etc/systemd/system/`:

```bash
sudo cp watchdogJetson.service /etc/systemd/system/
```

Open the service file for editing:

```bash
sudo vim /etc/systemd/system/watchdogJetson.service
```

### Update the Service File

Modify the following lines so they match your system:

```ini
User=<your_user_name_here>
Group=<your_group>
WorkingDirectory=</directory/where/watchdogJetson.py/is/located>
ExecStart=/usr/bin/python3 /directory/where/watchdogJetson.py/is/located/watchdogJetson.py
```

### Example

```ini
User=luca
Group=luca
WorkingDirectory=/home/luca/watchdogJetson
ExecStart=/usr/bin/python3 /home/luca/watchdogJetson/watchdogJetson.py
```

Make sure the username, group, and directory paths match your actual system configuration.

### Reload `systemd`

After saving the file, reload the `systemd` daemon:

```bash
sudo systemctl daemon-reload
```

### Enable the Service at Boot

Enable the service so it starts automatically on boot:

```bash
sudo systemctl enable watchdogjetson.service
```