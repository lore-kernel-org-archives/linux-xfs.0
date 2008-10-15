Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:22:54 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5MquB005729
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:22:52 -0700
Subject: TAKE 988142 - Remove use of m_ilock from mount structure as it no longer exists.
Message-Id: <20081015052433.4DE1B58FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:24:33 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove use of m_ilock from mount structure as it no longer exists.

Date:  Wed Oct 15 16:24:15 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-reclaim
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32338a
fs/xfs/xfsidbg.c - 1.371 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.371&r2=text&tr2=1.370&f=h
	- Remove use of m_ilock from mount structure as it no longer exists.
