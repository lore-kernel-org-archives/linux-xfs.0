Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Nov 2007 19:54:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAL3s7Jv017022
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2007 19:54:14 -0800
Subject: PARTIAL TAKE 973591 970324 - fix up tree walking with symlinks for attr
Message-Id: <20071121035411.6815B58C4C0A@chook.melbourne.sgi.com>
Date: Wed, 21 Nov 2007 14:54:11 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

fix up tree walking with symlinks for attr

Date:  Wed Nov 21 14:53:02 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30110a
xfstests/062.out - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/062.out.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Update the output now that getfattr code has changed with new
	  tree walking code.
