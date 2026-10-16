# scales-firmware

Configuration reference for building the **SCALES Compute Module** embedded Linux
image (PHYTEC phyCORE-i.MX8X / i.MX8QXP, Yocto `scarthgap`).

This repository does **not** contain the Yocto layer itself. It holds:

- a reference to the [`meta-scales-leviathan`](https://github.com/BroncoSpace-Lab/meta-scales-leviathan) layer,
- the BSP build configuration (`conf/`) that turns the stock PHYTEC BSP into a Leviathan build, and
- the device and network information needed to set up a host machine for the SCALES test bench.

---

## Repository Contents

| Path | Purpose |
|---|---|
| `meta-scales-leviathan/` | Git submodule that **references** the layer repo and pins the version this release was built with. You don't copy it anywhere; clone the layer straight into the BSP (see [Building the Image](#building-the-image)). |
| `conf/local.conf` | Selects the Leviathan machine and distro: `MACHINE ?= "imx8qxp-scales-leviathan"`, `DISTRO ?= "ampliphy-vendor"` |
| `conf/bblayers.conf` | The PHYTEC BSP layer stack, plus `${TOPDIR}/../sources/meta-scales-leviathan` |
| `conf/*.txt`, `conf/templateconf.cfg` | Standard BSP build-folder files, kept so the whole `conf/` folder can be dropped in as is |
| `scales-config-info.txt` | Test bench device reference: IP addresses, login details, wiring notes |
| `LICENSE` | MIT |

For what the layer itself contains (machine config, device tree, U-Boot changes, F´ deployment),
see the [`meta-scales-leviathan` README](https://github.com/BroncoSpace-Lab/meta-scales-leviathan/blob/main/README.md).

---

## Prerequisites

- A Linux build host set up for Yocto (see the PHYTEC BSP manual for required packages)
- The PHYTEC **`BSP-Yocto-NXP-i.MX8X-PD24.1.y`** BSP installed. The examples below assume it's at
  `~/BSP-Yocto-NXP-i.MX8X-PD24.1.y`.

BSP installation guide: <https://scales-docs.readthedocs.io/en/latest/imx_yocto_bsp/>

---

## Building the Image

### 1. Clone the layer into the BSP

```bash
cd ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/sources
git clone https://github.com/BroncoSpace-Lab/meta-scales-leviathan.git
```

### 2. Clone this repository

```bash
git clone https://github.com/BroncoSpace-Lab/scales-firmware.git ~/scales-firmware
```

You don't need `--recurse-submodules` here: the build uses the layer you cloned in step 1.

### 3. Replace the BSP build configuration

```bash
rm -rf ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/conf
cp -r ~/scales-firmware/conf ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/
```

Check the copy (no output means the folders are identical):

```bash
diff -rq ~/scales-firmware/conf ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/conf
```

### 4. Build

```bash
cd ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto
source sources/poky/oe-init-build-env build

bitbake-layers show-layers | grep scales     # meta-scales-leviathan should be listed
bitbake phytec-headless-image
```

The finished image is written to:

```
~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/deploy-ampliphy-vendor/images/imx8qxp-scales-leviathan/
```

For flashing and first boot, see the
[`meta-scales-leviathan` README](https://github.com/BroncoSpace-Lab/meta-scales-leviathan/blob/main/README.md#flashing-and-booting).

### Updating to a newer layer version

```bash
git -C ~/BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/sources/meta-scales-leviathan pull
```

Then run `bitbake phytec-headless-image` again.

---

## Host Machine Configuration

The SCALES test bench uses a private `10.3.2.0/24` network. Give the host machine's wired
interface the static address **`10.3.2.13/24`**. This is also the address the Leviathan's U-Boot
uses as its `serverip`.

Example with NetworkManager (replace `eth0` with your interface name from `ip link`):

```bash
sudo nmcli con add type ethernet ifname eth0 con-name scales-bench \
     ipv4.method manual ipv4.addresses 10.3.2.13/24
sudo nmcli con up scales-bench
```

### Network reference

| Device | Address |
|---|---|
| SCALES Leviathan (`eth0`) | `10.3.2.10` |
| SCALES Leviathan (`eth1`) | `10.3.2.11` |
| SCALES Jetson | `10.3.2.12` |
| Host machine (laptop) | `10.3.2.13` |
| Lucid camera | `10.3.2.8` |

### Leviathan access

| Item | Value |
|---|---|
| Serial console | `ttyLP2`, 115200 8N1 |
| F´ `ImxDeployment` | TCP port `50000` |
| UART GDS link | `/dev/ttyLP0`, 921600 8N1 |

Check the connection:

```bash
ping 10.3.2.10
ssh root@10.3.2.10
```

Login details and wiring notes for each device are in
[`scales-config-info.txt`](scales-config-info.txt).

---

## License

MIT. See [`LICENSE`](LICENSE).
