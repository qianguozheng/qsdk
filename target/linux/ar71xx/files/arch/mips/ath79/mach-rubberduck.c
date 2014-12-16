/*
 * Qualcomm-Atheros RubberDuck platform
 *
 * Copyright (c) 2014 The Linux Foundation. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <linux/platform_device.h>
#include <linux/ar8216_platform.h>

#include <asm/mach-ath79/ar71xx_regs.h>

#include "common.h"
#include "dev-eth.h"
#include "dev-m25p80.h"
#include "machtypes.h"

#define RUBBERDUCK_MAC0_OFFSET		0
#define RUBBERDUCK_MAC1_OFFSET		6

static struct ar8327_pad_cfg rubberduck_ar8327_pad0_cfg = {
	.mode = AR8327_PAD_MAC_RGMII,
	.txclk_delay_en = true,
	.rxclk_delay_en = true,
	.txclk_delay_sel = AR8327_CLK_DELAY_SEL1,
	.rxclk_delay_sel = AR8327_CLK_DELAY_SEL2,
};

static struct ar8327_pad_cfg rubberduck_ar8327_pad6_cfg = {
	.mode = AR8327_PAD_MAC_SGMII,
	.sgmii_txclk_phase_sel = AR8327_SGMII_CLK_PHASE_RISE,
	.sgmii_rxclk_phase_sel = AR8327_SGMII_CLK_PHASE_FALL,
};

static struct ar8327_platform_data rubberduck_ar8327_data = {
	.pad0_cfg = &rubberduck_ar8327_pad0_cfg,
	.pad6_cfg = &rubberduck_ar8327_pad6_cfg,
	.cpuport_cfg = {
		.force_link = 1,
		.speed = AR8327_PORT_SPEED_1000,
		.duplex = 1,
		.txpause = 1,
		.rxpause = 1,
	},
	.port6_cfg = {
		.force_link = 1,
		.speed = AR8327_PORT_SPEED_1000,
		.duplex = 1,
		.txpause = 1,
		.rxpause = 1,
	}
};

static struct mdio_board_info rubberduck_mdio0_info[] = {
	{
		.bus_id = "ag71xx-mdio.0",
		.phy_addr = 0,
		.platform_data = &rubberduck_ar8327_data,
	},
};

static void __init rubberduck_gmac_setup(void)
{
	void __iomem *base;
	u32 t;

	base = ioremap(QCA955X_GMAC_BASE, QCA955X_GMAC_SIZE);

	t = __raw_readl(base + QCA955X_GMAC_REG_ETH_CFG);

	t &= ~(QCA955X_ETH_CFG_RGMII_GMAC0 | QCA955X_ETH_CFG_SGMII_GMAC0);
	/* clear bit 6, then GMAC0 is RGMII, and GMAC1 is SGMII */
	t |= QCA955X_ETH_CFG_RGMII_GMAC0 | QCA955X_ETH_CFG_SGMII_GMAC0;

	__raw_writel(t, base + QCA955X_GMAC_REG_ETH_CFG);

	iounmap(base);
}

static void __init rubberduck_setup(void)
{
	u8 *art = (u8 *) KSEG1ADDR(0x1fff0000);

	ath79_register_m25p80(NULL);

	rubberduck_gmac_setup();

	ath79_register_mdio(0, 0x0);

	mdiobus_register_board_info(rubberduck_mdio0_info,
				    ARRAY_SIZE(rubberduck_mdio0_info));

	/* GMAC0 is connected to QCA8337 Port6 */
	ath79_init_mac(ath79_eth0_data.mac_addr, art + RUBBERDUCK_MAC0_OFFSET, 0);
	ath79_eth0_data.phy_if_mode = PHY_INTERFACE_MODE_SGMII;
	ath79_eth0_data.phy_mask = BIT(0);
	ath79_eth0_data.mii_bus_dev = &ath79_mdio0_device.dev;
	ath79_eth0_pll_data.pll_1000 = 0x06000000;
	ath79_register_eth(0);

	/* GMAC1 is connected to QCA8337 Port0 */
	ath79_init_mac(ath79_eth1_data.mac_addr, art + RUBBERDUCK_MAC1_OFFSET, 0);
	ath79_eth1_data.phy_if_mode = PHY_INTERFACE_MODE_RGMII;
	ath79_eth1_data.speed = SPEED_1000;
	ath79_eth1_data.duplex = DUPLEX_FULL;
	ath79_register_eth(1);
}

MIPS_MACHINE(ATH79_MACH_RUBBERDUCK, "RUBBERDUCK",
	     "Qualcomm-Atheros RubberDuck custom design", rubberduck_setup);
