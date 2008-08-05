Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:12:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757CPia024085
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:12:26 -0700
Subject: TAKE 981498 - use get_unaligned_* helpers
Message-Id: <20080805071337.3576B58C52A4@chook.melbourne.sgi.com>
Date: Tue,  5 Aug 2008 17:13:37 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

use get_unaligned_* helpers

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Date:  Tue Aug  5 17:12:48 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
harvey.harrison@gmail.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31813a
fs/xfs/xfs_inode.c - 1.515 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.515&r2=text&tr2=1.514&f=h
	- use get_unaligned_* helpers
