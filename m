Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 22:53:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9M5rbTY023391
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2007 22:53:39 -0700
Subject: TAKE 907752 - Fix build for FreeBSD
Message-Id: <20071022055334.D3D3558C38F1@chook.melbourne.sgi.com>
Date: Mon, 22 Oct 2007 15:53:34 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Mon Oct 22 15:53:10 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  rodrigc@crodrigues.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29935a
xfsprogs/libxfs/freebsd.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/freebsd.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Fix build for FreeBSD
