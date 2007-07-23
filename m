Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 19:03:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N23Cbm002626
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 19:03:14 -0700
From: donaldd@sgi.com
Subject: TAKE 967936 - Fix null pointer dereference in xfs_quota.
Message-Id: <20070723013859.5CAB12F34DEA@linuxbuild.melbourne.sgi.com>
Date: Mon, 23 Jul 2007 11:38:59 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix null pointer dereference in state_f.

Date:  Mon Jul 23 11:36:22 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  bnaujok, utako, nathans.

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29194a
xfsprogs/quota/state.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/state.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
