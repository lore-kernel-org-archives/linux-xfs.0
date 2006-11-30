Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 23:10:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAU7AIaG028626
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 23:10:19 -0800
Date: Thu, 30 Nov 2006 18:09:26 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200611300709.kAU79Q0H49207473@snort.melbourne.sgi.com>
Subject: TAKE 958692 - xfs_repair aborts if it encounters an inode with an invalid type.
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix up xfs_repair aborting if it finds an inode with an invalid inode type.


Date:  Thu Nov 30 18:08:37 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  NONE

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27589a
xfsprogs/doc/CHANGES - 1.226 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.226&r2=text&tr2=1.225&f=h
xfsprogs/repair/dinode.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dinode.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
