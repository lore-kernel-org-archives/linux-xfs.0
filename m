Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 05:49:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NCnm4p028316
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 05:49:50 -0700
Subject: PARTIAL TAKE 968563 -  kill move.[ch]
Message-Id: <20070823124944.33A4E58C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 22:49:44 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill move.[ch]

Kill uio related functions and defines now that they're unused.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug 23 22:49:17 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29480a
fs/xfs/support/move.h - 1.20 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/move.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- kill move.[ch] now they are unused.

fs/xfs/support/move.c - 1.19 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/move.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- kill move.[ch] now they are unused.

fs/xfs/Makefile-linux-2.6 - 1.208 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.208&r2=text&tr2=1.207&f=h
	- kill move.[ch] now they are unused.

fs/xfs/linux-2.6/xfs_linux.h - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
	- kill move.[ch] now they are unused.
