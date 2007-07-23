Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 19:15:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N2F5bm008490
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 19:15:08 -0700
Subject: TAKE 907752 - Fix up package creation with xfs_metadump and minor build warnings
Message-Id: <20070723021503.BEE3E58CC4C0@chook.melbourne.sgi.com>
Date: Mon, 23 Jul 2007 12:15:03 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon Jul 23 12:14:26 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  nathans@iaconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29196a
xfsprogs/include/Makefile - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/Makefile.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Add xfs_metadump.h to Makefile so it's packaged up correctly

xfsprogs/libxfs/rdwr.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/rdwr.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
xfsprogs/libxfs/init.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Fix build warning
