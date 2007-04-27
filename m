Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Apr 2007 02:15:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3R9F9fB023007
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 02:15:11 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA28429 for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 18:50:46 +1000
Subject: TAKE 963965 - Add lockdep support for XFS
Message-Id: <20070427085045.D7C6E5910FF9@chook.melbourne.sgi.com>
Date: Fri, 27 Apr 2007 18:50:45 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Add lockdep support for XFS


Date:  Fri Apr 27 18:47:16 AEST 2007
Workarea:  vpn-emea-sw-emea-160-20.emea.sgi.com:/home/lachlan/isms/2.6.x-lockdep
Inspected by:  
tes
dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28485a
fs/xfs/xfs_vnodeops.c - 1.695 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.695&r2=text&tr2=1.694&f=h
fs/xfs/xfs_vfsops.c - 1.518 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
fs/xfs/xfs_iget.c - 1.225 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.225&r2=text&tr2=1.224&f=h
fs/xfs/xfs_inode.h - 1.220 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.220&r2=text&tr2=1.219&f=h
fs/xfs/linux-2.6/mrlock.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/mrlock.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Add lockdep support for XFS
