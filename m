Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Jan 2007 22:24:39 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0N6OUqw019813
	for <xfs@oss.sgi.com>; Mon, 22 Jan 2007 22:24:33 -0800
Date: Tue, 23 Jan 2007 17:23:31 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200701230623.l0N6NVFd100598439@snort.melbourne.sgi.com>
Subject: TAKE 960195 - Patch for attr and acl to correctly use libtool while crosscompiling
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use libtool correctly when cross-compiling


Date:  Tue Jan 23 17:23:10 AEDT 2007
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Diego 'Flameeyes' Pettenò [flameeyes@gentoo.org]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27985a
acl/VERSION - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/VERSION.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
acl/doc/CHANGES - 1.93 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/doc/CHANGES.diff?r1=text&tr1=1.93&r2=text&tr2=1.92&f=h
acl/m4/package_attrdev.m4 - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/m4/package_attrdev.m4.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- Use libtool correctly when cross-compiling
