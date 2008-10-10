Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:09:34 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A59Tjt001895
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:09:31 -0700
Subject: TAKE 988139 - xfsidbg update for mount inode list
Message-Id: <20081010051102.8851758FA1A4@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:11:02 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfsidbg update for mount inode list

Kill the idbg users of the mount inode list. Compile tested
only.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 16:10:42 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32296a
fs/xfs/xfsidbg.c - 1.369 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.369&r2=text&tr2=1.368&f=h
	- xfsidbg update for mount inode list
