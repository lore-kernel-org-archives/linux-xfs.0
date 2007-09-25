Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 20:53:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8P3qtQ3012401
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 20:52:57 -0700
Subject: TAKE 970978 - Fix a couple mkfs.xfs issues
Message-Id: <20070925035254.80AE758C4C0A@chook.melbourne.sgi.com>
Date: Tue, 25 Sep 2007 13:52:54 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix wiping old AG headers and purge whack buffers


Date:  Tue Sep 25 13:52:20 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29767a
xfsprogs/mkfs/xfs_mkfs.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
	- Fix wiping old AG headers and purge whack buffers
