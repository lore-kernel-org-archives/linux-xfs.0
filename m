Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 May 2007 18:08:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4O18nWt012711
	for <xfs@oss.sgi.com>; Wed, 23 May 2007 18:08:51 -0700
Subject: TAKE 965149 - xfs_fsr - Temp working directory has full access for everyone
Message-Id: <20070524010845.62E0E58CA531@chook.melbourne.sgi.com>
Date: Thu, 24 May 2007 11:08:45 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Restrict access to temp working directory


Date:  Thu May 24 11:07:57 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Nathan Scott [nscott@aconex.com]

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28670a
xfsdump/VERSION - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/VERSION.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
xfsdump/doc/CHANGES - 1.100 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/doc/CHANGES.diff?r1=text&tr1=1.100&r2=text&tr2=1.99&f=h
	- Update to version 2.2.45

xfsdump/fsr/xfs_fsr.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsdump/fsr/xfs_fsr.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- Restrict access to temp working directory
