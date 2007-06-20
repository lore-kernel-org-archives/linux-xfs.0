Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 20:42:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K3gQdo028184
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 20:42:28 -0700
Subject: PARTIAL TAKE 966569 - Fix a bunch of XFSQA tests
Message-Id: <20070620034223.0E87658C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 13:42:22 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

add null files tests to auto group


Date:  Wed Jun 20 13:41:41 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28940a
xfstests/group - 1.107 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.107&r2=text&tr2=1.106&f=h
	- add null files tests to auto group.

xfstests/140 - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/140.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- leave bad files around for post mortem on failure.
