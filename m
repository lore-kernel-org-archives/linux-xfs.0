Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 18:26:47 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0N2QRqc008415
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 18:26:37 -0800
Subject: TAKE 907752 - Fix minor problems with attr man pages
Message-Id: <20080123022643.41F5558C4C10@chook.melbourne.sgi.com>
Date: Wed, 23 Jan 2008 13:26:43 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Wed Jan 23 13:25:47 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  rrt@sc3d.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30415a
attr/man/man3/attr_set.3 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/man/man3/attr_set.3.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
attr/man/man3/attr_get.3 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/man/man3/attr_get.3.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Remove extra '

attr/man/man2/listxattr.2 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/man/man2/listxattr.2.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- Improve description for list argument
