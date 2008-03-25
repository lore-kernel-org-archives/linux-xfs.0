Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:39:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4dmE9029930
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:39:50 -0700
Subject: TAKE 979086 - XFSQA 103: filter ln output
Message-Id: <20080325044018.9E58558C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 15:40:18 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

XFSQA 103: filter ln output

More recent versions of ln (version >= 6.0) have a different error
output. update the filter to handle this.

Date:  Tue Mar 25 15:39:58 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/xfs-cmds
Inspected by:  hch@infradead.org,jeffpc@josefsipek.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30705a
xfstests/103 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/103.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- update filter to handle new ln error output.
