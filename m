Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 18:03:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1622xcR011848
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 18:03:02 -0800
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA26582 for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 13:03:21 +1100
Subject: TAKE 971186 - add __init/__exit mark to specific init/cleanup functions
Message-Id: <20080206020321.20C7158C4C11@chook.melbourne.sgi.com>
Date: Wed,  6 Feb 2008 13:03:21 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

add __init/__exit mark to specific init/cleanup functions


Date:  Wed Feb  6 11:36:42 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-init
Inspected by:  Denis Cheng <crquan@gmail.com>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30459a
fs/xfs/xfs_vfsops.c - 1.551 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.551&r2=text&tr2=1.550&f=h
fs/xfs/support/uuid.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/uuid.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
fs/xfs/support/ktrace.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.408 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.408&r2=text&tr2=1.407&f=h
	- add __init/__exit mark to specific init/cleanup functions
