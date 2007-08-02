Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:29:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727TCbm014035
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:29:14 -0700
Subject: TAKE 968554 - Filestreams fixes for 2.6.23
Message-Id: <20070802072912.8B3D058F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:29:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Export the filestreams trace buffer for modularised debugging setups

Signed-Off-By: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 17:28:29 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29306a
fs/xfs/linux-2.6/xfs_ksyms.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Export the filestreams trace buffer.
