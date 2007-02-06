Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 22:47:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l166l63c021473
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 22:47:08 -0800
Subject: TAKE 960192 - XFS sysctl cleanup
Message-Id: <20070206064702.4E7B358FF657@chook.melbourne.sgi.com>
Date: Tue,  6 Feb 2007 17:47:02 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

XFS sysctl cleanups

Removes unneeded sysctl insert at head behaviour.
Cleans up sysctl definitions to use C99 initialisers.
Patch provided by Eric W. Biederman.
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Date:  Tue Feb  6 17:46:02 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,ebiederm@xmission.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28031a
fs/xfs/linux-2.6/xfs_sysctl.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- sysctl cleanup patch provided by Eric W. Biederman.
	  Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
