Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Aug 2006 22:10:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7L59pDW013591
	for <linux-xfs@oss.sgi.com>; Sun, 20 Aug 2006 22:10:03 -0700
Subject: TAKE 955558 - userspace Makefiles
Message-Id: <20060821050906.5F2ED58C4C00@chook.melbourne.sgi.com>
Date: Mon, 21 Aug 2006 15:09:06 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix symlink detection in userspace Makefiles

Date:  Mon Aug 21 15:06:46 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26823a
xfsprogs/doc/CHANGES - 1.217 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.217&r2=text&tr2=1.216&f=h
xfsdump/doc/CHANGES - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
xfsprogs/include/buildmacros - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildmacros.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
xfsdump/include/buildmacros - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/include/buildmacros.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h

Fix symlink detection in userspace Makefiles

Date:  Mon Aug 21 15:08:50 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26825a
dmapi/include/buildmacros - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/dmapi/include/buildmacros.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
acl/include/buildmacros - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/buildmacros.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
attr/include/buildmacros - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/attr/include/buildmacros.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
xfstests/include/buildmacros - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/include/buildmacros.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
