Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 17:50:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k720nVDW029582
	for <linux-xfs@oss.sgi.com>; Tue, 1 Aug 2006 17:49:42 -0700
Subject: TAKE 954896 - xfsprogs
Message-Id: <20060802004850.9695D58C6F55@chook.melbourne.sgi.com>
Date: Wed,  2 Aug 2006 10:48:50 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix buffer sizing issue for large pagesize systems, affecting mkfs
auto-device-type-detection heuristics.

Date:  Wed Aug  2 10:48:16 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-cmds
Inspected by:  Arthur Corliss <acorliss@nevaeh-linux.org>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:26662a
xfsprogs/doc/CHANGES - 1.214 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.214&r2=text&tr2=1.213&f=h
xfsprogs/libdisk/fstype.c - 1.10 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libdisk/fstype.c.diff?r1=text&tr1=1.10&r2=text&tr2=1.9&f=h
