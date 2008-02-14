Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 20:30:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1E4UfHK026035
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 20:30:44 -0800
Subject: PARTIAL TAKE 977326 -
Message-Id: <20080214043101.011A558C4C11@chook.melbourne.sgi.com>
Date: Thu, 14 Feb 2008 15:31:00 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.mangrove@engr.sgi.com
Cc: xfs@oss.sgi.com

walk_tree.h is not a devel package file


Date:  Thu Feb 14 15:30:24 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30491a
attr/include/Makefile - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/Makefile.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- walk_tree.h is not a installable/devel package file
