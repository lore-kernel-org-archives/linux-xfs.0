Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:01:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4910kAW005802
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:00:49 -0700
Subject: TAKE 981362 - update of xfstests 018,081,082 for onlink/gen# changes
Message-Id: <20080509010131.2139D58C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:01:31 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-bugs-internal@sgi.com

Filter out onlink (because of v2 inodes by default) and
gen# (because of random generation).

Date:  Fri May  9 10:56:30 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31049a
xfstests/common.log - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.log.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
xfstests/081.ugquota.trans_inode - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/081.ugquota.trans_inode.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
xfstests/018.trans_inode - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/018.trans_inode.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/082.trans_inode - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/082.trans_inode.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/082.op.irix - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/082.op.irix.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/018.op.linux - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/018.op.linux.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/018.op.irix - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/018.op.irix.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
xfstests/082.op.linux - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/082.op.linux.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Filter out onlink (because of v2 inodes by default) and gen# (because of random generation).

Subject: TAKE update xfstests/dmapi....Makefile.in

regenerate dmapi Makefile in using automake

Date:  Thu May  1 16:07:18 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31014a
xfstests/dmapi/aclocal.m4 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/aclocal.m4.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- regenerate using aclocal

xfstests/dmapi/src/suite1/cmd/Makefile.in - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/suite1/Makefile.in.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- regenerate using automake


automake doesn't have "default" target but uses "all" target instead

Date:  Mon May  5 14:28:09 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  tes,bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31021a
xfstests/Makefile - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/Makefile.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- automake doesn't have "default" target but uses "all" target instead
