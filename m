Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:41:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21exEM009518
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:41:01 -0700
Subject: PARTIAL TAKE 971186 - Fix up sparse warnings
Message-Id: <20071102014058.6F86B58C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 12:40:58 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix up sparse warnings.

These are mostly locking annotations, marking things static,
casts where needed and declaring stuff in header files.

Date:  Fri Nov  2 12:40:25 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org,lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30002a
fs/xfs/xfs_log.c - 1.343 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.343&r2=text&tr2=1.342&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_buf_item.h - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.h.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_da_btree.h - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_da_btree.h.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_log_recover.c - 1.331 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.331&r2=text&tr2=1.330&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_trans_item.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_item.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_vfsops.c - 1.546 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.546&r2=text&tr2=1.545&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_mount.c - 1.416 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.416&r2=text&tr2=1.415&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_btree.h - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_trans.h - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_bmap.h - 1.102 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.102&r2=text&tr2=1.101&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_bmap.c - 1.380 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.380&r2=text&tr2=1.379&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_rename.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_attr.c - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_dir2.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Fix up sparse warnings.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
	- Fix up sparse warnings.

fs/xfs/linux-2.6/xfs_globals.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- Fix up sparse warnings.

fs/xfs/linux-2.6/xfs_ioctl32.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_mru_cache.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Fix up sparse warnings.

fs/xfs/xfs_filestream.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Fix up sparse warnings.
