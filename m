Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:03:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L83hmH031452
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:03:44 -0700
Subject: TAKE 981520 - Remove build warnings with debug compile
Message-Id: <20080521080429.BFE2458C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 18:04:29 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove build warnings with debug compile


Date:  Wed May 21 18:03:42 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31211a
fs/xfs/xfsidbg.c - 1.351 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.351&r2=text&tr2=1.350&f=h
	- Remove build warnings in debug compile
