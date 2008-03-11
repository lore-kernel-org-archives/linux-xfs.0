Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Mar 2008 05:33:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2BCXApP013030
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2008 05:33:14 -0700
Subject: TAKE 978682 - Update xfsidbg code after AIL listhead conversion
Message-Id: <20080311123337.CBA3158C4C0F@chook.melbourne.sgi.com>
Date: Tue, 11 Mar 2008 23:33:37 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update xfsidbg code after AIL listhead conversion.


Date:  Tue Mar 11 23:33:13 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  jeffpc@josefsipek.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30641a
fs/xfs/xfsidbg.c - 1.346 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.346&r2=text&tr2=1.345&f=h
	- Convert AIL debug code to struct list_head.
