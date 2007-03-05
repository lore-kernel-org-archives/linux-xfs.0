Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 08:28:51 -0800 (PST)
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l25GSi6p002278
	for <xfs@oss.sgi.com>; Mon, 5 Mar 2007 08:28:44 -0800
Subject: TAKE 961696 - reducing the number of random number functions.
Message-Id: <20070305164748.38B2552AEE@lab41.emea.sgi.com>
Date: Mon,  5 Mar 2007 16:47:48 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

reducing the number of random number functions.

Patch provided by Joe Perches
Signed-off-by: Joe Perches <joe@perches.com>

Date:  Tue Mar  6 03:25:54 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-34.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  
lachlan
joe@perches.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28209a
fs/xfs/xfs_error.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
fs/xfs/xfs_alloc.c - 1.185 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.185&r2=text&tr2=1.184&f=h
fs/xfs/support/debug.h - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
fs/xfs/support/debug.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- reducing the number of random number functions.
	  Signed-off-by: Joe Perches <joe@perches.com>
