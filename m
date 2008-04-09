Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:24:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m394Ok4J013713
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:24:47 -0700
Subject: PARTIAL TAKE 976035 - Replace __inline with inline
Message-Id: <20080409042520.53DE158C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 14:25:20 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Replace __inline with inline

Remove the remaining uses of __inline in the XFS code base.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Date:  Wed Apr  9 14:24:55 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  harvey.harrison@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30774a
fs/xfs/quota/xfs_qm_stats.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_stats.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- replace __inline with inline

fs/xfs/linux-2.6/xfs_cred.h - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_cred.h.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- replace __inline with inline

fs/xfs/linux-2.6/xfs_stats.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- replace __inline with inline
