Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:20:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4KD0w026679
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:20:15 -0700
Subject: TAKE 907752 -  xfsqa: make 054 _require_quota 
Message-Id: <20080325042043.480FA58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:20:43 +1100 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

054 needs quota support to run, but doesn't make that explicit.

Signed-off-by:  Eric Sandeen <sandeen@sandeen.net>


Date:  Tue Mar 25 15:20:18 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/xfs-cmds
Inspected by:  esandeen

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30700a
xfstests/054 - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/054.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- 054 needs quota support to run, but doesn't make that explicit.
