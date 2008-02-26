Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 17:43:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q1hO6R023489
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 17:43:27 -0800
Subject: PARTIAL TAKE 976035 - cleanup vnode use in xfs_link
Message-Id: <20080226014348.7A34F58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 26 Feb 2008 12:43:48 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup vnode use in xfs_link

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Feb 26 12:43:13 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30547a
fs/xfs/xfs_vnodeops.c - 1.742 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.742&r2=text&tr2=1.741&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.278 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.278&r2=text&tr2=1.277&f=h
fs/xfs/xfs_vnodeops.h - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- cleanup vnode use in xfs_link
