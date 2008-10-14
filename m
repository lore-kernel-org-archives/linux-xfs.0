Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 23:02:57 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E62smw027643
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:02:54 -0700
Subject: PARTIAL TAKE 988236 - xfstests/189 remount test
Message-Id: <20081014060428.7CA0858FA1E9@chook.melbourne.sgi.com>
Date: Tue, 14 Oct 2008 17:04:28 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

test out a remount bug where ro->rw doesn't update xfs flag and thinks it is
still readonly. Test using touch.
Code provided by Christoph Hellwig.
Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct 14 17:00:59 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32320a
xfstests/189 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/189.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- test out a remount bug where ro->rw doesn't update xfs flag and thinks it is
	  still readonly. Test using touch.
	  Code provided by Christoph Hellwig.


Subject: TAKE 985710 983964 - add comment to test about its related bugs in bugworks
Date:  Mon Sep 15 13:45:24 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32116a
xfstests/189 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/189.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- add comment to test about its related bugs in bugworks
