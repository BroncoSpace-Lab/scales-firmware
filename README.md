# Installing `meta-scales-leviathan`

This guide covers:
1. Installing the `meta-scales-leviathan` layer into the base i.MX8QXP PHYTEC BSP

---

## Install the `meta-scales-leviathan` Layer in the Base i.MX8QXP PHYTEC BSP

To bake the custom `scales-leviathan` Linux image, pull the `meta-scales-leviathan` folder into the Yocto sources directory:

```bash
git clone https://github.com/BroncoSpace-Lab/meta-scales-leviathan.git /BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/sources/
```

Next, copy the `conf` folder into the Yocto build directory. If a `conf` folder already exists there, replace it with this version:

```bash
cp -r conf /BSP-Yocto-NXP-i.MX8X-PD24.1.y/yocto/build/
```

Then follow the standard BitBake process for the image using the instructions here:

https://scales-docs.readthedocs.io/en/latest/imx_yocto_bsp/



