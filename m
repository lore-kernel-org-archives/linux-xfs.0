Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 00:26:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7F7PuDW016510
	for <linux-xfs@oss.sgi.com>; Tue, 15 Aug 2006 00:26:08 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA13903 for <linux-xfs@oss.sgi.com>; Tue, 15 Aug 2006 17:25:16 +1000
Subject: TAKE 904196 - Merge up to 2.4.33.
Message-Id: <20060815072515.EEDC758C8A40@chook.melbourne.sgi.com>
Date: Tue, 15 Aug 2006 17:25:15 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Date:  Tue Aug 15 17:24:28 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/2.4.x-xfs
Inspected by:  tes,chatz,marcelo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.4.x-xfs-melb


Modid:  2.4.x-xfs-melb:linux:26774a
include/asm-sparc64/sfafsr.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/sfafsr.h
include/asm-sparc64/const.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/const.h
drivers/net/wireless/airo.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/airo.h
CREDITS - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/CREDITS.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
Documentation/Changes - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/Documentation/Changes.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
Documentation/Configure.help - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/Documentation/Configure.help.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
Makefile - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/Makefile.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
README - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/README.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/alpha/kernel/pci_iommu.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/alpha/kernel/pci_iommu.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/i386/config.in - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/i386/config.in.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
arch/i386/kernel/dmi_scan.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/i386/kernel/dmi_scan.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
arch/i386/kernel/i387.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/i386/kernel/i387.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/i386/kernel/io_apic.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/i386/kernel/io_apic.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
arch/ia64/ia32/sys_ia32.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/ia64/ia32/sys_ia32.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
arch/parisc/kernel/ioctl32.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/parisc/kernel/ioctl32.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/parisc/kernel/sys_parisc32.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/parisc/kernel/sys_parisc32.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
arch/ppc64/kernel/ioctl32.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/ppc64/kernel/ioctl32.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
arch/ppc64/kernel/signal.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/ppc64/kernel/signal.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/ppc64/kernel/sys_ppc32.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/ppc64/kernel/sys_ppc32.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
arch/ppc64/lib/memcpy.S - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/ppc64/lib/memcpy.S.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/s390x/kernel/linux32.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/s390x/kernel/linux32.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
arch/sparc/math-emu/math.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc/math-emu/math.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/kernel/entry.S - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/entry.S.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/kernel/irq.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/irq.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/kernel/pci_iommu.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/pci_iommu.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/sparc64/kernel/process.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/process.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
arch/sparc64/kernel/sbus.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/sbus.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/sparc64/kernel/smp.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/smp.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
arch/sparc64/kernel/sys_sparc32.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/sys_sparc32.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
arch/sparc64/kernel/traps.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/traps.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/kernel/ttable.S - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/ttable.S.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/kernel/unaligned.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/unaligned.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/sparc64/kernel/winfixup.S - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/kernel/winfixup.S.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
arch/sparc64/lib/debuglocks.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/sparc64/lib/debuglocks.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
arch/x86_64/ia32/socket32.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/x86_64/ia32/socket32.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
arch/x86_64/kernel/process.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/x86_64/kernel/process.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
arch/x86_64/kernel/signal.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/arch/x86_64/kernel/signal.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/acpi/system.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/acpi/system.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/block/ll_rw_blk.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/block/ll_rw_blk.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/cdrom/cdrom.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/cdrom/cdrom.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/cdrom/sbpcd.c - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/cdrom/sbpcd.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/char/drm/drm_stub.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/char/drm/drm_stub.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/char/drm/radeon_mem.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/char/drm/radeon_mem.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/char/dummy_keyb.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/char/dummy_keyb.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/i2c/scx200_acb.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/i2c/scx200_acb.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/ide/ide-dma.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/ide/ide-dma.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/ide/ide-io.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/ide/ide-io.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/ide/setup-pci.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/ide/setup-pci.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/input/Config.in - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/input/Config.in.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/mtd/chips/amd_flash.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/mtd/chips/amd_flash.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/mtd/chips/cfi_cmdset_0001.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/mtd/chips/cfi_cmdset_0001.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/mtd/chips/cfi_cmdset_0002.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/mtd/chips/cfi_cmdset_0002.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/mtd/chips/cfi_cmdset_0020.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/mtd/chips/cfi_cmdset_0020.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/3c59x.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/3c59x.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/au1000_eth.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/au1000_eth.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/b44.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/b44.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/bonding/bond_alb.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/bonding/bond_alb.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/e1000/e1000_hw.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/e1000/e1000_hw.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
drivers/net/e1000/e1000_main.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/e1000/e1000_main.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
drivers/net/sis900.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/sis900.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/net/via-rhine.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/via-rhine.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/wan/sdla.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wan/sdla.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
drivers/net/wireless/airo.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/airo.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/net/wireless/airo_cs.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/airo_cs.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/net/wireless/hermes.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/hermes.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/net/wireless/hermes.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/hermes.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/net/wireless/orinoco.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/wireless/orinoco.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/scsi/aic7xxx/aic7xxx_osm.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/aic7xxx/aic7xxx_osm.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/scsi/dpt_i2o.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/dpt_i2o.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/scsi/scsi_scan.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/scsi_scan.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/usb/host/ehci-hcd.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/usb/host/ehci-hcd.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/usb/host/ehci-q.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/usb/host/ehci-q.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/usb/host/usb-uhci.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/usb/host/usb-uhci.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/usb/serial/usbserial.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/usb/serial/usbserial.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
fs/binfmt_elf.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/binfmt_elf.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
fs/dcache.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/dcache.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/ext2/namei.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/ext2/namei.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/ext3/inode.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/ext3/inode.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
fs/inode.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/inode.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
fs/jbd/recovery.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/jbd/recovery.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/locks.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/locks.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/namei.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/namei.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
fs/nfs/inode.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/nfs/inode.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/nfsd/nfsctl.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/nfsd/nfsctl.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/partitions/msdos.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/partitions/msdos.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/proc/base.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/proc/base.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
fs/quota_v2.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/quota_v2.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/smbfs/dir.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/smbfs/dir.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/smbfs/proc.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/fs/smbfs/proc.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
include/asm-sparc64/atomic.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/atomic.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
include/asm-sparc64/bitops.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/bitops.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
include/asm-sparc64/softirq.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/softirq.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
include/asm-sparc64/spinlock.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/spinlock.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
include/asm-sparc64/system.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-sparc64/system.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
include/asm-x86_64/i387.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/asm-x86_64/i387.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
include/linux/i2c.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/i2c.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
include/linux/ide.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/ide.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
include/linux/nfs_fs_i.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/nfs_fs_i.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
include/linux/pci_ids.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/pci_ids.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
include/linux/proc_fs.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/proc_fs.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
include/linux/sysctl.h - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/sysctl.h.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
include/net/sctp/sctp.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/net/sctp/sctp.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
include/scsi/scsi.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/scsi/scsi.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
init/main.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/init/main.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
ipc/shm.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/ipc/shm.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
kernel/kmod.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/kernel/kmod.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
kernel/panic.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/kernel/panic.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
kernel/ptrace.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/kernel/ptrace.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
kernel/sysctl.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/kernel/sysctl.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
net/8021q/vlan.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/8021q/vlan.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
net/core/ethtool.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/core/ethtool.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
net/core/neighbour.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/core/neighbour.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
net/ipv4/af_inet.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/af_inet.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
net/ipv4/igmp.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/igmp.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
net/ipv4/netfilter/arp_tables.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/arp_tables.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
net/ipv4/netfilter/ip_conntrack_core.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/ip_conntrack_core.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
net/ipv4/netfilter/ip_nat_snmp_basic.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/ip_nat_snmp_basic.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
net/ipv4/netfilter/ip_queue.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/ip_queue.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
net/ipv4/netfilter/ip_tables.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/ip_tables.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
net/ipv4/netfilter/ipt_recent.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/netfilter/ipt_recent.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
net/ipv4/route.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv4/route.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
net/ipv6/ip6_flowlabel.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv6/ip6_flowlabel.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
net/ipv6/mcast.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv6/mcast.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
net/ipv6/netfilter/ip6_queue.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv6/netfilter/ip6_queue.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
net/ipv6/netfilter/ip6_tables.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/ipv6/netfilter/ip6_tables.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
net/sctp/sm_statefuns.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/sctp/sm_statefuns.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
net/sctp/sm_statetable.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/sctp/sm_statetable.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
net/sctp/ulpqueue.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/net/sctp/ulpqueue.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
scripts/ver_linux - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/scripts/ver_linux.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/net/forcedeth.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/net/forcedeth.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/ide/pci/atiixp.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/ide/pci/atiixp.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
split-patches/xfs-modules - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/xfs-modules.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
split-patches/series - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/series.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
split-patches/rwsem-backport - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/rwsem-backport.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
split-patches/kdb-i386 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/kdb-i386.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
split-patches/kdb-common - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/kdb-common.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
split-patches/dmapi-enable - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/dmapi-enable.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
split-patches/acl-backport - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/acl-backport.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
split-patches/wait-call_usermodehelper - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/wait-call_usermodehelper.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
split-patches/cache_defs - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/cache_defs.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
split-patches/docs-update2 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/docs-update2.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
split-patches/downgrade_write-backport - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/downgrade_write-backport.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/scsi/sata_promise.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_promise.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
drivers/scsi/sata_promise.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_promise.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/sata_sil.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_sil.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
drivers/scsi/sata_sis.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_sis.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/sata_svw.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_svw.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
drivers/scsi/sata_sx4.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_sx4.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/libata.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/libata.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/libata-scsi.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/libata-scsi.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
drivers/scsi/libata-core.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/libata-core.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/sata_via.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_via.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/sata_vsc.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_vsc.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/usb/gadget/rndis.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/usb/gadget/rndis.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
include/linux/ata.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/ata.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
include/linux/libata.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/libata.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
drivers/scsi/sata_uli.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_uli.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/scsi/ata_piix.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/ata_piix.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/scsi/sata_nv.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_nv.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
split-patches/hash-backport - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/hash-backport.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
include/linux/libata-compat.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/include/linux/libata-compat.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
drivers/scsi/ahci.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/ahci.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
drivers/scsi/sata_qstor.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/drivers/scsi/sata_qstor.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
split-patches/pquota-enable - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/pquota-enable.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
split-patches/quota-delalloc - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/quota-delalloc.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
split-patches/xattr-backport - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.4-xfs/split-patches/xattr-backport.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
