Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 21:48:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I4maXO002748
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 21:48:40 -0700
Subject: TAKE 982930 - userland changes for dir2 shortform structures fixes on ARM old ABI
Message-Id: <20080618044930.5DAC558C4C3F@chook.melbourne.sgi.com>
Date: Wed, 18 Jun 2008 14:49:30 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Userland side of kernel changes for fixing issues with dir2 ondisk differences
on old ARM ABI boxes.

Provided by Eric Sandeen.

Date:  Wed Jun 18 14:47:55 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31325a
xfsprogs/doc/CHANGES - 1.254 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h
xfsprogs/include/xfs_dir2_sf.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_dir2_sf.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
xfsprogs/include/platform_defs.h.in - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/platform_defs.h.in.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- Userland side of kernel changes for fixing issues with dir2 ondisk differences
	  on old ARM ABI boxes.
