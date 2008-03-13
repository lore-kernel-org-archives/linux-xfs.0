Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Mar 2008 20:22:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2D3MTmv009069
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2008 20:22:31 -0700
Subject: TAKE 977766 - Update mkfs manpage for new defaults:
Message-Id: <20080313032256.4501558C4C0F@chook.melbourne.sgi.com>
Date: Thu, 13 Mar 2008 14:22:56 +1100 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

    Update mkfs manpage for new defaults:
    
    log, attr and inodes v2,
    Drop the ability to turn unwritten extents off completly,
    reduce imaxpct for big filesystems, less AGs for single disks configs.


Date:  Thu Mar 13 14:22:34 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/xfs-cmds
Inspected by:  esandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30662a
xfsprogs/man/man8/mkfs.xfs.8 - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man8/mkfs.xfs.8.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- Update mkfs manpage for new defaults:
