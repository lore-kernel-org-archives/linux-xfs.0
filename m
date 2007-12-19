Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 19:22:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ3MIpI018947
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 19:22:27 -0800
Subject: TAKE 974873 - Add mknod sanity test
Message-Id: <20071219032226.BB45D58C4C0F@chook.melbourne.sgi.com>
Date: Wed, 19 Dec 2007 14:22:26 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add mknod sanity test.

Date:  Wed Dec 19 14:22:04 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30274a
xfstests/184 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/184
	- mknod sanity test

xfstests/184.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/184.out
	- mknod sanity test output

xfstests/group - 1.117 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.117&r2=text&tr2=1.116&f=h
	- Add mknod sanity test to metadata and auto groups
