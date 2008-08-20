Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 20:31:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7K3ViRV011382
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 20:31:44 -0700
Subject: TAKE 981498 - Use xfs_idestroy() to cleanup an inode.
Message-Id: <20080820033302.AF92058C52A8@chook.melbourne.sgi.com>
Date: Wed, 20 Aug 2008 13:33:02 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use xfs_idestroy() to cleanup an inode.

Date:  Wed Aug 20 13:32:01 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  
lachlan
david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31927a
fs/xfs/xfs_inode.c - 1.520 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.520&r2=text&tr2=1.519&f=h
	- Use xfs_idestroy() to cleanup an inode.
