Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:07:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72B7ebm025787
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:07:43 -0700
Subject: PARTIAL TAKE 968563 - remove confusing INT_ comments in xfs_bmap_btree.c
Message-Id: <20070802110740.53C2A58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:07:40 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

remove confusing INT_ comments in xfs_bmap_btree.c

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 21:07:17 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29317a
fs/xfs/xfs_bmap_btree.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- Cleanup unneeded comments.
