Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:14:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491E3gL007037
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:14:06 -0700
Subject: PARTIAL TAKE 981498 - Remove unused kmem_free() args from XFS DMAPI code.
Message-Id: <20080509011445.ABF3D58C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:14:45 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove unused kmem_free() args from XFS DMAPI code.


Date:  Fri May  9 11:14:19 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31054a
fs/xfs/dmapi/xfs_dm.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- remove unused kmem_free() arg.
