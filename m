Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 16:35:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l170Zg3c018388
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 16:35:44 -0800
Subject: TAKE 960897 - Remove a bunch of unused functions from XFS
Message-Id: <20070207003537.1F36858C4C27@chook.melbourne.sgi.com>
Date: Wed,  7 Feb 2007 11:35:37 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove a bunch of unused functions from XFS.

Patch provided by Eric Sandeen (sandeen@sandeen.net).
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Wed Feb  7 11:35:11 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28038a
fs/xfs/xfs_da_btree.c - 1.174 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.c.diff?r1=text&tr1=1.174&r2=text&tr2=1.173&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_da_btree.h - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_rtalloc.h - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.h.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_rtalloc.c - 1.105 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.105&r2=text&tr2=1.104&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap_btree.h - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap_btree.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_error.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_error.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_bmap.c - 1.364 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.364&r2=text&tr2=1.363&f=h
	- Remove unused functions.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
