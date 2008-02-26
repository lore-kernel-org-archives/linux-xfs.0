Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 21:28:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q5SLes013184
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 21:28:23 -0800
Subject: REOPEN 974005 - Undo bit ops cleanup mod due to regression on 32-bit powermac platform.
Message-Id: <20080226052844.9BBC558C4C0F@chook.melbourne.sgi.com>
Date: Tue, 26 Feb 2008 16:28:44 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Undo bit ops cleanup mod due to regression on 32-bit powermac platform.

Date:  Tue Feb 26 16:27:51 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  lachlan
Undoes mod:  xfs-linux-melb:xfs-kern:30202a
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30558a
fs/xfs/xfs_bit.h - 1.23 - changed
