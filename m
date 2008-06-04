Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 02:08:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5498iAg015204
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 02:08:46 -0700
Subject: TAKE -  mkfs/xfs_growfs with ASCII CI support with incorrect output
Message-Id: <20080604090934.8A91458C4C3F@chook.melbourne.sgi.com>
Date: Wed,  4 Jun 2008 19:09:34 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up incorrect mkfs/growfs output for ascii-ci mode


Date:  Wed Jun  4 19:08:53 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31275a
xfsprogs/mkfs/xfs_mkfs.c - 1.91 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.91&r2=text&tr2=1.90&f=h
	- Fix up incorrect mkfs output for ascii-ci mode and update usage

xfsprogs/growfs/xfs_growfs.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_growfs.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Fix up incorrect growfs output for ascii-ci mode
