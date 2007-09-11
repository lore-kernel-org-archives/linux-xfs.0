Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 18:18:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8B1Hv4p022434
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 18:18:12 -0700
Subject: TAKE 970324 - Fix symlink handling in getfattr, getfacl and setfacl
Message-Id: <20070911011753.0B45C58C4C09@chook.melbourne.sgi.com>
Date: Tue, 11 Sep 2007 11:17:52 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix symlink handling in getfattr, getfacl and setfacl


Date:  Tue Sep 11 11:17:08 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Utako Kusaka <utako@tnes.nec.co.jp>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29637a
attr/getfattr/getfattr.c - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/getfattr/getfattr.c.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
	- Fix symlink handling in getfattr

acl/setfacl/setfacl.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/setfacl.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Fix symlink handling in setfacl

acl/getfacl/getfacl.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/getfacl/getfacl.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Fix symlink handling in getfacl
