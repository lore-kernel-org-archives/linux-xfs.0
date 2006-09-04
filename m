Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Sep 2006 18:37:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k841bODW012301
	for <linux-xfs@oss.sgi.com>; Sun, 3 Sep 2006 18:37:36 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA19011 for <linux-xfs@oss.sgi.com>; Mon, 4 Sep 2006 11:36:41 +1000
Subject: TAKE 955696 - cleanup, xfs_read
Message-Id: <20060904013640.AB70258CF851@chook.melbourne.sgi.com>
Date: Mon,  4 Sep 2006 11:36:40 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Minor cleanup from dio locking fix, remove an extra conditional.

Date:  Mon Sep  4 11:36:19 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26908a
linux-2.6/xfs_lrw.c - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
