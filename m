Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Apr 2007 17:54:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l330s9fB000643
	for <xfs@oss.sgi.com>; Mon, 2 Apr 2007 17:54:11 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA23394 for <xfs@oss.sgi.com>; Tue, 3 Apr 2007 10:54:07 +1000
Subject: TAKE cleanup - remove ilen refs from vnodeops.c
Message-Id: <20070403005407.C15D458FF80A@chook.melbourne.sgi.com>
Date: Tue,  3 Apr 2007 10:54:07 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove unused ilen variable and references.


Date:  Tue Apr  3 10:53:20 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  lachlan@sgi.com,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28344a
fs/xfs/xfs_vnodeops.c - 1.694 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.694&r2=text&tr2=1.693&f=h
	- Remove unused ilen variable and references.
