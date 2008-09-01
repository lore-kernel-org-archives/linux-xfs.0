Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 19:08:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m8128IgA011352
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 19:08:18 -0700
Subject: TAKE 967805 - xfsprogs.pot file is not built if src file deleted and po/Makefile not updated
Message-Id: <20080901020941.4A4CB58C52AB@chook.melbourne.sgi.com>
Date: Mon,  1 Sep 2008 12:09:41 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Point out the actual source file missing when generateing pkg.pot file
rather than obscure error message


Date:  Mon Sep  1 12:08:00 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  tes, nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32010a
xfsprogs/include/buildrules - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/buildrules.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Point out the actual source file missage when generating pkg.pot file
	  rather than obscure error message
