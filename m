Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:10:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G2Arbm027141
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:10:55 -0700
Subject: TAKE 962476 - xfs_bmap -p missing FLAGS field
Message-Id: <20070716021051.F122558C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 12:10:51 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Always show flags column with xfs_bmap -vp options


Date:  Mon Jul 16 12:09:39 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29140a
xfsprogs/io/bmap.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/bmap.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Always show flags column with xfs_bmap -vp options
