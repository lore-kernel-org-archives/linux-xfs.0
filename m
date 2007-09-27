Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 20:51:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8R3phrv002173
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 20:51:45 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-Id: <20070927035137.8AE11303F3CB@linuxbuild.melbourne.sgi.com>
Date: Thu, 27 Sep 2007 13:51:37 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove fs/xfs/support/Makefile as building for 2.4 kernels is no longer supported from this tree

Date:  Thu Sep 27 13:49:55 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29791a
fs/xfs/support/Makefile - 1.23 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/Makefile.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
