Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 22:19:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F5J2UG004228
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 22:19:04 -0700
From: donaldd@sgi.com
Subject: TAKE 971046 - Remove unused HAVE_SPLICE macro
Message-Id: <20080415051937.4D85635CE07B@linuxbuild.melbourne.sgi.com>
Date: Tue, 15 Apr 2008 15:19:37 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove unused HAVE_SPLICE macro.

HAVE_SPLICE was part of the infrastructure for building 2.4 and 2.6
kernels out of the same tree. Now we don't build 2.4 kernels this 

Date:  Tue Apr 15 15:18:53 AEST 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30878a
fs/xfs/xfs.h - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- Remove unused HAVE_SPLICE macro.
