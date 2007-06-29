Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:34:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T6XvtL029136
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:34:01 -0700
Subject: TAKE 958214 - xfs_bmap '-v' flag has no effect on a realtime file system
Message-Id: <20070629063353.1B88E58C38F1@chook.melbourne.sgi.com>
Date: Fri, 29 Jun 2007 16:33:53 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Fri Jun 29 16:33:35 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29029a
xfsprogs/io/bmap.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/bmap.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- xfs_bmap '-v' flag has no effect on a realtime file system
