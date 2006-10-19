Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 18:35:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9J1Z6aG023235
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 18:35:08 -0700
Date: Thu, 19 Oct 2006 11:34:16 +1000 (AEST)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200610190134.k9J1YGGc11073613@snort.melbourne.sgi.com>
Subject: TAKE 957164 - 
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up prefetched v1 inode nlink check and repair in xfs_repair


Date:  Thu Oct 19 11:33:46 AEST 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  mvalluri@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27235a
xfsprogs/repair/phase7.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/phase7.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- pv:957164
	  Fix up prefetched v1 inode nlink check and repair in xfs_repair
