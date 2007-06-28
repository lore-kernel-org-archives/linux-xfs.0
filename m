Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 01:30:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S8TwtL003001
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 01:30:00 -0700
Subject: TAKE  965902 - Add filestreams support to xfs_io
Message-Id: <20070628082955.64C7A58C38F1@chook.melbourne.sgi.com>
Date: Thu, 28 Jun 2007 18:29:55 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Thu Jun 28 18:29:21 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29015a
xfsprogs/db/inode.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/inode.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Add filestreams support to xfs_db inode output

xfsprogs/VERSION - 1.173 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.173&r2=text&tr2=1.172&f=h
xfsprogs/doc/CHANGES - 1.242 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.242&r2=text&tr2=1.241&f=h
	- Update to 2.9.1

xfsprogs/include/xfs_fs.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_fs.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
xfsprogs/include/xfs_dinode.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dinode.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Add filestreams support

xfsprogs/man/man3/xfsctl.3 - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/man/man3/xfsctl.3.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Document filestream inode attr

xfsprogs/io/attr.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/io/attr.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Add filestreams support to xfs_io
