Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 21:41:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l544exWt015527
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 21:41:01 -0700
Subject: TAKE 965626 - xfsqa - test 030 doesn't test what it's supposed to
Message-Id: <20070604044054.C4CA958C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 14:40:54 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Make sure the repair tests dirty the filesystem before corrupting it.

Date:  Mon Jun  4 14:40:06 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  ddiss

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28770a
xfstests/common.repair - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.repair.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfstests/030.out.irix - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/030.out.irix.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/030.out.linux - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/030.out.linux.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/148.out - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/148.out.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Make sure the repair tests dirty the filesystem before corrupting it.
