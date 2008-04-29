Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 21:19:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T4JXlj015071
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 21:19:36 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id OAA04274 for <xfs@oss.sgi.com>; Tue, 29 Apr 2008 14:20:17 +1000
Subject: TAKE 980021 - test fix of noattr2
Message-Id: <20080429042016.E0E8F58C4C15@chook.melbourne.sgi.com>
Date: Tue, 29 Apr 2008 14:20:16 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.comxfs@oss.sgi.com

Test out the fix for 980021 for checking that noattr2 is now working.

Date:  Tue Apr 29 14:16:20 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31004a
xfstests/187 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/187
	- check that noattr2 mount option works

xfstests/187.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/187.out
	- out file for 187

xfstests/group - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
	- add 187
