Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 22:06:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K56cdo022273
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 22:06:40 -0700
Subject: TAKE 966505 - cleanup dir2 macro shouting
Message-Id: <20070620050635.AA89358C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 15:06:35 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fixup kdb module code after removing dir2 shouting.


Date:  Wed Jun 20 15:05:52 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28948a
fs/xfs/xfsidbg.c - 1.315 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.315&r2=text&tr2=1.314&f=h
	- Fixup kdb module code after removing dir2 shouting.
