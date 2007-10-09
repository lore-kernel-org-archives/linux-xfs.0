Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Oct 2007 17:31:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l990VImo000355
	for <xfs@oss.sgi.com>; Mon, 8 Oct 2007 17:31:19 -0700
Subject: TAKE 971597 - fsck.xfs doesn't verify that the device exists
Message-Id: <20071009003114.2DEEB58C38F1@chook.melbourne.sgi.com>
Date: Tue,  9 Oct 2007 10:31:14 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make fsck.xfs verify the device exists


Date:  Tue Oct  9 10:30:48 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  wtucker@donobi.com,nathans@debian.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29851a
xfsprogs/fsck/xfs_fsck.sh - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/fsck/xfs_fsck.sh.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Make fsck.xfs verify the device exists
