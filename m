Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:46:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Bk8bm011474
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:46:11 -0700
Subject: PARTIAL TAKE 968563 - Remove xfs_physmem
Message-Id: <20070802114608.8BA0B58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:46:08 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove xfs_physmem

Now that nobody's using it, remove xfs_physmem & friends.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Thu Aug  2 21:45:47 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29325a
fs/xfs/linux-2.6/xfs_globals.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- remove unused xfs_physmem & friends.

fs/xfs/linux-2.6/xfs_globals.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- remove unused xfs_physmem & friends.

fs/xfs/linux-2.6/xfs_super.c - 1.384 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.384&r2=text&tr2=1.383&f=h
	- remove unused xfs_physmem & friends.

fs/xfs/linux-2.4/xfs_globals.h - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_globals.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
	- remove unused xfs_physmem & friends.

fs/xfs/linux-2.4/xfs_globals.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_globals.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- remove unused xfs_physmem & friends.

fs/xfs/linux-2.4/xfs_super.c - 1.337 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.337&r2=text&tr2=1.336&f=h
	- remove unused xfs_physmem & friends.
