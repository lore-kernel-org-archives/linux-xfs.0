Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 22:26:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N5Pxbm016734
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 22:26:01 -0700
Subject: TAKE 967983 - Fix xfs_quota "quota -n" command for project IDs
Message-Id: <20070723052557.CCD7D58CC4C5@chook.melbourne.sgi.com>
Date: Mon, 23 Jul 2007 15:25:57 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon Jul 23 15:25:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29200a
xfsprogs/quota/quota.c - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/quota.c.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Fix "quota -n" command for project IDs
