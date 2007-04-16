Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Apr 2007 22:21:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3G5LDfB027136
	for <xfs@oss.sgi.com>; Sun, 15 Apr 2007 22:21:15 -0700
Subject: TAKE 963466 - remove the unnecessary word in the log message
Message-Id: <20070416052109.0483F5903EDB@chook.melbourne.sgi.com>
Date: Mon, 16 Apr 2007 15:21:08 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Thanks to Utako Kusaka.

Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
Get rid of redundant "required" in msg.

Date:  Mon Apr 16 15:19:51 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  utako@tnes.nec.co.jp,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28416a
fs/xfs/xfs_log_recover.c - 1.318 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.318&r2=text&tr2=1.317&f=h
	- Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
	  Get rid of redundant "required" in msg.
