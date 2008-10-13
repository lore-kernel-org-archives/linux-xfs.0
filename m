Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:45:15 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6iq32002220
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:45:13 -0700
Subject: TAKE 988140 - Remove exported symbol xfs_syncsub() since it no longer exists.
Message-Id: <20081013064632.A172C58C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:46:32 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove exported symbol xfs_syncsub() since it no longer exists.

Date:  Mon Oct 13 17:45:58 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32313a
fs/xfs/linux-2.6/xfs_ksyms.c - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
	- Remove exported symbol xfs_syncsub() since it no longer exists.
