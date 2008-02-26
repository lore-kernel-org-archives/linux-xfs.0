Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 17:51:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q1pmWP025661
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 17:51:51 -0800
Subject: PARTIAL TAKE 976035 - cleanup vnode use in xfs_bmap.c
Message-Id: <20080226015211.A004358C4C0F@chook.melbourne.sgi.com>
Date: Tue, 26 Feb 2008 12:52:11 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup vnode use in xfs_bmap.c

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Feb 26 12:51:29 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30553a
fs/xfs/xfs_bmap.c - 1.386 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.386&r2=text&tr2=1.385&f=h
	- cleanup vnode use in xfs_bmap.c
