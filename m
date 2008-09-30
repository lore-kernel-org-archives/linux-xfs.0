Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 19:02:37 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U22SFp021794
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 19:02:31 -0700
Subject: TAKE 985583 - Make xfs_btree_check_ptr() debug-only code.
Message-Id: <20080930020354.3983458C52B4@chook.melbourne.sgi.com>
Date: Tue, 30 Sep 2008 12:03:54 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Make xfs_btree_check_ptr() debug-only code.

Date:  Tue Sep 30 12:03:01 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32224a
fs/xfs/xfs_btree.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- Make xfs_btree_check_ptr() debug-only code.
