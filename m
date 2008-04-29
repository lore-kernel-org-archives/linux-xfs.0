Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 21:16:38 -0700 (PDT)
Received: from emu.melbourne.sgi.com (emu.melbourne.sgi.com [134.14.54.11])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3T4GS39014565
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 21:16:30 -0700
Subject: TAKE 979606 - 
Message-Id: <20080429060011.BCF5A50886E7@emu.melbourne.sgi.com>
Date: Tue, 29 Apr 2008 16:00:11 +1000 (EST)
From: tes@emu.melbourne.sgi.com
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.melbourne.sgi.com

Test out bug in xfs_attr_shortform_bytesfit for its use of m_attroffset
instead of di_forkoff.


Date:  Mon Apr 14 15:24:55 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30863a
xfstests/186 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/186
xfstests/186.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/186.out
	- Test out bug in xfs_attr_shortform_bytesfit for its use of m_attroffset
	  instead of di_forkoff.

xfstests/group - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
	- Add 186 for attr.


Subject: TAKE 980021 - fix noattr2

Test out the fix for 980021 for checking that noattr2 is now working.


Date:  Tue Apr 29 14:16:20 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31004a
xfstests/187 - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/187
	- check that noattr2 mount option works

xfstests/187.out - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/187.out
	- out file for 187

xfstests/group - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/group.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
	- add 187
