Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 00:26:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m767QMmV032052
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 00:26:23 -0700
Subject: TAKE 981498 - Fix fallout from semaphore -> completion changes.
Message-Id: <20080806072735.1DD3858C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 17:27:35 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix fallout from semaphore -> completion changes.

Date:  Wed Aug  6 17:26:51 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31839a
fs/xfs/xfsidbg.c - 1.360 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.360&r2=text&tr2=1.359&f=h
	- Fix fallout from semaphore -> completion changes.
