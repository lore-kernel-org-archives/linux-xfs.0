Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 16:49:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBK0naqw019738
	for <xfs@oss.sgi.com>; Tue, 19 Dec 2006 16:49:38 -0800
Date: Wed, 20 Dec 2006 11:48:39 +1100 (AEDT)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200612200048.kBK0mdWR67637476@snort.melbourne.sgi.com>
Subject: TAKE 959034 - Fix debian breakage with last attr patch
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix link breakage in debian with last patch


Date:  Wed Dec 20 11:48:02 AEDT 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  nathans@debian.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27779a
attr/VERSION - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/VERSION.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
attr/doc/CHANGES - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/doc/CHANGES.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
attr/libattr/Makefile - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/Makefile.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
attr/debian/changelog - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/debian/changelog.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
attr/libattr/syscalls.c - 1.18 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/libattr/syscalls.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Fix link breakage in debian with last patch
