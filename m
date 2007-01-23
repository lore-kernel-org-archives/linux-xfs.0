Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 22:18:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N6IVqw018338
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 22:18:33 -0800
Date: Tue, 23 Jan 2007 17:17:31 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200701230617.l0N6HVYp101231640@snort.melbourne.sgi.com>
Subject: PARTIAL TAKE 960195 - Patch for attr and acl to correctly use libtool while crosscompiling
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix cross-compile issues with libtool and compiler.


Date:  Tue Jan 23 17:16:34 AEDT 2007
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Diego 'Flameeyes' Pettenò [flameeyes@gentoo.org]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27984a
attr/VERSION - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/VERSION.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
attr/doc/CHANGES - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/doc/CHANGES.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
attr/include/builddefs.in - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/builddefs.in.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
attr/m4/package_utilies.m4 - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/m4/package_utilies.m4.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
attr/m4/package_globals.m4 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/m4/package_globals.m4.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Fix cross-compile issues with libtool and compiler.
