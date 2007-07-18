Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 01:02:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6I82abm008625
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 01:02:38 -0700
Subject: TAKE 967742 - Fix another breakage due to dir_stack.* removal
Message-Id: <20070718080233.D872E58C52B5@chook.melbourne.sgi.com>
Date: Wed, 18 Jul 2007 18:02:33 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Wed Jul 18 18:01:45 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29173a
xfsprogs/po/Makefile - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/po/Makefile.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- Update translation stuff for new/deleted files in xfs_repair
