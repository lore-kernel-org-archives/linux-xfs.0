Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 00:57:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6I7uaDW009051
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 00:56:50 -0700
Subject: TAKE 954577 - log/rt-as-file
Message-Id: <20060718075558.3EF0858C4C03@chook.melbourne.sgi.com>
Date: Tue, 18 Jul 2006 17:55:58 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix use of realtime/log subvols as-a-file, like data subvol, for testing.

Date:  Tue Jul 18 17:55:36 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26575a
xfsprogs/mkfs/xfs_mkfs.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
