Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Sep 2007 23:31:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8H6VHuw011558
	for <xfs@oss.sgi.com>; Sun, 16 Sep 2007 23:31:19 -0700
Subject: PARTIAL TAKE 968563 - Kill unused IOMAP_EOF flag
Message-Id: <20070917063113.5251358C4C09@chook.melbourne.sgi.com>
Date: Mon, 17 Sep 2007 16:31:13 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Kill unused IOMAP_EOF flag

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Sep 17 16:30:34 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29705a
fs/xfs/xfs_iomap.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- kill unused IOMAP_EOF flag

fs/xfs/xfs_iomap.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- kill unused IOMAP_EOF flag
