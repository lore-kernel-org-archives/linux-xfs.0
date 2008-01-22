Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jan 2008 22:11:47 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0M6BZqO017463
	for <xfs@oss.sgi.com>; Mon, 21 Jan 2008 22:11:39 -0800
Subject: TAKE 907752 - Fix metadump build warning
Message-Id: <20080122061150.E56A458C4C10@chook.melbourne.sgi.com>
Date: Tue, 22 Jan 2008 17:11:50 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Tue Jan 22 17:11:21 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  nathans@debian.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30411a
xfsprogs/debian/changelog - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/debian/changelog.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- Update debian changelog

xfsprogs/db/metadump.c - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Fix metadump build warning
