Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 May 2008 17:01:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4801M2g013749
	for <xfs@oss.sgi.com>; Wed, 7 May 2008 17:01:24 -0700
Subject: TAKE 980705 - Correctly detect if dmapi is present or not in tests 175-177
Message-Id: <20080508000205.2E92158C4C15@chook.melbourne.sgi.com>
Date: Thu,  8 May 2008 10:02:05 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Correctly detect if dmapi is present or not in tests 175-177


Date:  Thu May  8 10:01:42 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31032a
xfstests/177 - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/177.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
xfstests/175 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/175.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
xfstests/176 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/176.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Correctly detect if dmapi is present.
