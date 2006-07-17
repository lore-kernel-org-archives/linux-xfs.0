Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 03:48:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HAlTDW022559
	for <linux-xfs@oss.sgi.com>; Mon, 17 Jul 2006 03:47:37 -0700
Subject: TAKE 954366 - prep for i_blksize removal
Message-Id: <20060717104652.0489158C4C01@chook.melbourne.sgi.com>
Date: Mon, 17 Jul 2006 20:46:51 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Update XFS for i_blksize removal from generic inode structure


Date:  Mon Jul 17 20:46:05 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26565a
linux-2.6/xfs_iops.c - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
