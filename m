Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 19:31:22 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m912VHqH013319
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 19:31:18 -0700
Subject: TAKE 987246 - Show buffer address with debug hexdump on corruption
Message-Id: <20081001023252.9FFEA58C52B4@chook.melbourne.sgi.com>
Date: Wed,  1 Oct 2008 12:32:52 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Show buffer address with debug hexdump on corruption



Date:  Wed Oct  1 12:32:18 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32233a
fs/xfs/support/debug.c - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.c.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- Show buffer address with debug hexdump on corruption
