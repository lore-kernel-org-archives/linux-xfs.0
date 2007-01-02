Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Jan 2007 23:36:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l027aqqw013711
	for <linux-xfs@oss.sgi.com>; Mon, 1 Jan 2007 23:36:53 -0800
Date: Tue, 2 Jan 2007 18:35:58 +1100 (AEDT)
From: Allan Randall <allanr@snort.melbourne.sgi.com>
Message-Id: <200701020735.l027Zwpt80352840@snort.melbourne.sgi.com>
Subject: TAKE  - Dmapi QA build
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, asg-qa@melbourne.sgi.com

Dmapi QA build fix


Date:  Tue Jan  2 18:34:57 AEDT 2007
Workarea:  snort.melbourne.sgi.com:/home/allanr/isms/xfs-cmds-2
Inspected by:  ddiss

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27826a
xfstests/dmapi/Makefile.in - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/Makefile.in.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- added default make option

xfstests/include/buildmacros - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/include/buildmacros.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- removed special case for dmapi dir
