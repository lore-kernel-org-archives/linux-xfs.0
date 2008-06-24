Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 23:50:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O6oKFI018342
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 23:50:22 -0700
Subject: PARTIAL TAKE 981526 - XFSQA - Add CI test
Message-Id: <20080624065116.34BBA58C4C3F@chook.melbourne.sgi.com>
Date: Tue, 24 Jun 2008 16:51:16 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add CI stat/create/unlink test for multiple directory forms


Date:  Tue Jun 24 16:50:22 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31348a
xfstests/188 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/188
xfstests/188.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/188.out
	- Do CI stat/create/unlink test for multiple directory forms

xfstests/group - 1.121 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.121&r2=text&tr2=1.120&f=h
	- Add test 188
