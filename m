Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 20:09:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB449hAI005525
	for <xfs@oss.sgi.com>; Mon, 3 Dec 2007 20:09:45 -0800
Subject: TAKE 973591 - add more code to acl tree walking
Message-Id: <20071204040949.C5EF658C4C0F@chook.melbourne.sgi.com>
Date: Tue,  4 Dec 2007 15:09:49 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Add some code to the tree walking to better handle file descriptors.
Provided by Andreas G.

Date:  Tue Dec  4 15:08:45 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  agruen@suse.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30195a
acl/VERSION - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/VERSION.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
acl/doc/CHANGES - 1.99 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/doc/CHANGES.diff?r1=text&tr1=1.99&r2=text&tr2=1.98&f=h
acl/setfacl/setfacl.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/setfacl.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
acl/setfacl/do_set.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/setfacl/do_set.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
acl/getfacl/getfacl.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/getfacl/getfacl.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
acl/libmisc/walk_tree.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/libmisc/walk_tree.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
acl/include/walk_tree.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/acl/include/walk_tree.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
