Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 18:29:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D1Stp9005690
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 18:28:58 -0700
Subject: TAKE 980705 - xfsqa 17[5-7] - fix "unmount" typo
Message-Id: <20080513012938.45EE158C4C29@chook.melbourne.sgi.com>
Date: Tue, 13 May 2008 11:29:38 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix silly "unmount" typo in dmapi test.


Date:  Tue May 13 11:29:01 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31069a
xfstests/177 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/177.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/175 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/175.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfstests/176 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/176.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Fix silly "unmount" typo in dmapi test.
