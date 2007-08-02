Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:28:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72BS1bm004543
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:28:02 -0700
Subject: PARTIAL TAKE 968563 - endianess annotations for xfs_bmbt_rec_t
Message-Id: <20070802112800.0B9C858F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:27:59 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

endianess annotations for xfs_bmbt_rec_t

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 21:27:34 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29321a
fs/xfs/xfs_bmap_btree.h - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- Add endian annotations for xfs_bmbt_rec_t operations.

fs/xfs/xfs_bmap_btree.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- Add endian annotations for xfs_bmbt_rec_t operations.

fs/xfs/xfs_inode.c - 1.469 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.469&r2=text&tr2=1.468&f=h
	- Add endian annotations for xfs_bmbt_rec_t operations.

fs/xfs/xfs_bmap.c - 1.375 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.375&r2=text&tr2=1.374&f=h
	- Add endian annotations for xfs_bmbt_rec_t operations.
