Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Aug 2007 00:25:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7F7Oxbm004071
	for <xfs@oss.sgi.com>; Wed, 15 Aug 2007 00:25:05 -0700
From: donaldd@sgi.com
Subject: TAKE 969187 - Fix xfs_quota disable, enable, off and remove commands
Message-Id: <20070815072459.061C52759E21@linuxbuild.melbourne.sgi.com>
Date: Wed, 15 Aug 2007 17:24:58 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix xfs_quota disable, enable, off and remove commands.
Fix provided by Utako Kusaka.

Date:  Wed Aug 15 17:23:44 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/xfs-cmds
Inspected by:  utako@tnes.nec.co.jp

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29395a
xfsprogs/doc/CHANGES - 1.245 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.245&r2=text&tr2=1.244&f=h
xfsprogs/quota/state.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/quota/state.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
