Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 11:15:34 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l11JFSqw012562
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 11:15:29 -0800
Subject: TAKE 956828 - xfsqa test failures when quota and gquota options are used
Message-Id: <20070201191432.7BDE11F71F6@attica.americas.sgi.com>
Date: Thu,  1 Feb 2007 13:14:32 -0600 (CST)
From: wkendall@sgi.com (Bill Kendall)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com, xfs@sgi.com, sgi.bugs.xfs@sgi.com

Log a message for each quota file restored, not just the first one.


Date:  Thu Feb  1 11:13:53 PST 2007
Workarea:  attica.americas.sgi.com:/data/lwork/attica1/dmfgrp/4.0_chroot/wkendall/xfs-cmds
Inspected by:  dgc

The following file(s) were checked into:
  bonnie.engr.sgi.com:/isms/xfs-cmds/master


Modid:  master:xfs-cmds:220674a
xfsdump/restore/content.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/restore/content.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
