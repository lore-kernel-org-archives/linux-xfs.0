Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 17:18:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1E1IV4K012650
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 17:18:33 -0800
Subject: PARTIAL TAKE 971186 - Fix regression due to refcache removal
Message-Id: <20080214011850.8F03858C4C11@chook.melbourne.sgi.com>
Date: Thu, 14 Feb 2008 12:18:50 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix regression due to refcache removal

Date:  Thu Feb 14 12:17:28 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-test
Inspected by:  donaldd
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30490a
fs/xfs/xfs_vnodeops.c - 1.733 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.733&r2=text&tr2=1.732&f=h
	- Fix regression due to refcache removal
