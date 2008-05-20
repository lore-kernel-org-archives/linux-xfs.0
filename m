Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:49:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1mtnJ002426
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:49:32 -0700
Subject: PARTIAL TAKE 981951 - rename error2 goto label in xfs_fs_fill_super
Message-Id: <20080520014941.920A158C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:49:41 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

rename error2 goto label in xfs_fs_fill_super

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:49:23 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31198a
fs/xfs/linux-2.6/xfs_super.c - 1.426 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.426&r2=text&tr2=1.425&f=h
	- rename error2 goto label in xfs_fs_fill_super.
