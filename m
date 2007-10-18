Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 21:03:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I43N1P032593
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 21:03:27 -0700
Subject: 971596 971186 - Undo mod xfs-linux-melb:xfs-kern:29845a due to a regression
Message-Id: <20071018040320.F318C58C38F1@chook.melbourne.sgi.com>
Date: Thu, 18 Oct 2007 14:03:20 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Undo mod xfs-linux-melb:xfs-kern:29845a due to a regression

Date:  Thu Oct 18 14:02:08 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-buflock
Inspected by:  lachlan
Undoes mod:  xfs-linux-melb:xfs-kern:29845a
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29902a
fs/xfs/xfsidbg.c - 1.340 - changed
fs/xfs/linux-2.6/xfs_buf.h - 1.122 - changed
fs/xfs/linux-2.6/xfs_buf.c - 1.247 - changed
