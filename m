Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 21:46:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB85kWqw000941
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 21:46:34 -0800
Subject: REOPEN 958693 - Restore xfs/list.h
Message-Id: <20061208053305.5136658CA5AD@chook.melbourne.sgi.com>
Date: Fri,  8 Dec 2006 16:33:05 +1100 (EST)
From: chatz@sgi.com (David Chatterton)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Undo rename of xfs/list.h since this is effectively part of the XFS development interface that has already shipped.


Date:  Fri Dec  8 16:32:10 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/chatz/isms/xfs-cmds
Inspected by:  bnaujok
Undoes mod:  master-melb:xfs-cmds:27635a

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27668a
xfsprogs/include/libxfs.h - 1.59 - changed
xfsprogs/include/Makefile - 1.30 - changed
xfsprogs/libxfs/cache.c - 1.9 - changed
xfsprogs/include/xfs_list.h - 1.2 - renamed to xfsprogs/include/list.h 1.4
