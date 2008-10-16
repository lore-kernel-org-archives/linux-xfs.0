Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:47:25 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4lN23014521
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:47:23 -0700
Subject: TAKE 988143 - xfs_trans_delete_ail() is now xfs_trans_ail_delete()
Message-Id: <20081016044904.B544258FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:49:04 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfs_trans_delete_ail() is now xfs_trans_ail_delete()

Date:  Thu Oct 16 15:48:46 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32354a
fs/xfs/linux-2.6/xfs_ksyms.c - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
	- xfs_trans_delete_ail() is now xfs_trans_ail_delete()
