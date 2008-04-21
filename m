Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 00:53:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L7rKYs019932
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 00:53:22 -0700
Subject: TAKE 977765 - update xfs_admin to add set/clear of lazy-count feature
Message-Id: <20080421075357.415A558C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 17:53:57 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add lazy-counter enable/disable capability on existing filesystems


Date:  Mon Apr 21 17:53:16 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30908a
xfsprogs/db/xfs_admin.sh - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/xfs_admin.sh.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Execute bits changed from xxx to ---
	  Add lazy-count conversion feature

xfsprogs/VERSION - 1.180 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.180&r2=text&tr2=1.179&f=h
xfsprogs/doc/CHANGES - 1.252 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.252&r2=text&tr2=1.251&f=h
	- Bump version to 2.9.8

xfsprogs/man/man8/xfs_admin.8 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_admin.8.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfsprogs/man/man8/xfs_repair.8 - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/xfs_repair.8.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/repair/globals.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/globals.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
xfsprogs/repair/phase1.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase1.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/repair/xfs_repair.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/xfs_repair.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- Add lazy-counter conversion feature
