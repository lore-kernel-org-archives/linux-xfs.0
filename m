Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Sep 2006 17:49:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8S0nNaG022428
	for <xfs@oss.sgi.com>; Wed, 27 Sep 2006 17:49:25 -0700
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com [134.14.54.237]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA01292 for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 10:48:44 +1000
Subject: TAKE xfs_db - ring command fix
Message-Id: <20060928004844.4D83758CF853@chook.melbourne.sgi.com>
Date: Thu, 28 Sep 2006 10:48:44 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix up ring command in xfs_db for its argument handling
of the index.


Date:  Thu Sep 28 10:47:51 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27071a
xfsprogs/db/io.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/io.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Fix up ring command in xfs_db for its argument handling
	  of the index.
	  Fix from utako@tnes.nec.co.jp (Utako Kusaka).

xfsprogs/doc/CHANGES - 1.221 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.221&r2=text&tr2=1.220&f=h
	- Add xfs_db ring command fix
