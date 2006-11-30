Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 22:54:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAU6sLaG026450
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 22:54:23 -0800
Date: Thu, 30 Nov 2006 17:53:15 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200611300653.kAU6rFhN49198148@snort.melbourne.sgi.com>
Subject: PARTIAL TAKE 954550 - xfs_db problems
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix libxfs SEGV when attempting to mount a non-XFS filesystem.


Date:  Thu Nov 30 17:52:33 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27588a
xfsprogs/doc/CHANGES - 1.225 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.225&r2=text&tr2=1.224&f=h
xfsprogs/libxfs/init.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/init.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- Fix libxfs SEGV when attempting to mount a non-XFS filesystem.
