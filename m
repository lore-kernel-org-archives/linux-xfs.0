Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 18:40:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9J1eNaG024608
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 18:40:26 -0700
Date: Thu, 19 Oct 2006 11:39:34 +1000 (AEST)
From: Barry Naujok <bnaujok@snort.melbourne.sgi.com>
Message-Id: <200610190139.k9J1dYUV11075412@snort.melbourne.sgi.com>
Subject: TAKE 957194 - Fix LEAFN node level is 1 bogus warning in xfs_repair
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com


Date:  Thu Oct 19 11:38:43 AEST 2006
Workarea:  snort.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  roger@filmlight.ltd.uk

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:27238a
xfsprogs/VERSION - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/VERSION.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
xfsprogs/doc/CHANGES - 1.223 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/doc/CHANGES.diff?r1=text&tr1=1.223&r2=text&tr2=1.222&f=h
	- Bump version to 2.8.15

xfsprogs/repair/dir2.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/dir2.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- pv:957194
	  Fix LEAFN node level is 1 bogus warning in xfs_repair
