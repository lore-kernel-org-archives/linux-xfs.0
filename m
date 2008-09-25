Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 17:49:21 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P0nIW9001180
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:49:18 -0700
Subject: TAKE 985583 - make btree tracing generic
Message-Id: <20080925005044.A846058C52AE@chook.melbourne.sgi.com>
Date: Thu, 25 Sep 2008 10:50:44 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make btree tracing generic

Make the existing bmap btree tracing generic so that it applies to all
btree types.

Some fragments lifted from a patch by Dave Chinner.

This adds two files that were missed from the previous btree tracing
checkin.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Sep 25 10:50:03 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32210a
fs/xfs/xfs_btree_trace.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree_trace.c
fs/xfs/xfs_btree_trace.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree_trace.h
	- make btree tracing generic
