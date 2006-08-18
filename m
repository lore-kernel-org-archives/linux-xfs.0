Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 17:10:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7I0AADW026171
	for <linux-xfs@oss.sgi.com>; Thu, 17 Aug 2006 17:10:24 -0700
Subject: TAKE 955515 - realtime growfs
Message-Id: <20060818000926.57EF958C8A48@chook.melbourne.sgi.com>
Date: Fri, 18 Aug 2006 10:09:26 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix a porting botch on the realtime subvol growfs code path.

Date:  Fri Aug 18 10:08:56 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26806a
xfs_rtalloc.c - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
linux-2.6/xfs_linux.h - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
linux-2.4/xfs_linux.h - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_linux.h.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
