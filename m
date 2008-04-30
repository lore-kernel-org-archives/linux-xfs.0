Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 00:42:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3U7gSOu017564
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:42:30 -0700
Subject: TAKE 979416 - Include linux/random.h in all builds
Message-Id: <20080430074307.019CC58C4C15@chook.melbourne.sgi.com>
Date: Wed, 30 Apr 2008 17:43:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Include linux/random.h in all builds, not just debug builds.


Date:  Wed Apr 30 17:40:15 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31008a
fs/xfs/support/debug.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Include linux/random.h in all builds.

fs/xfs/linux-2.6/xfs_linux.h - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- Include linux/random.h in all builds.
