Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 01:39:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S8dBtL007311
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 01:39:13 -0700
Subject: TAKE 966972 - make sure the library link respects LDFLAGS
Message-Id: <20070628083908.6C03658C38F1@chook.melbourne.sgi.com>
Date: Thu, 28 Jun 2007 18:39:08 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Thu Jun 28 18:38:39 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  SpanKY <vapier@gentoo.org>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29016a
dmapi/include/buildmacros - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/include/buildmacros.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
acl/include/buildmacros - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/buildmacros.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
attr/include/buildmacros - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/buildmacros.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfsdump/include/buildmacros - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/buildmacros.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- make sure the library link respects LDFLAGS
