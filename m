Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Aug 2007 21:59:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l724xKbm022989
	for <xfs@oss.sgi.com>; Wed, 1 Aug 2007 21:59:24 -0700
Subject: TAKE 968166 - XFSQA 122: TOT XFS type checking fails
Message-Id: <20070802045919.52D2858F4B6B@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 14:59:19 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: sgi.bugs.xfs@engr.sgi.com

Fix up QA for xfsprogs 2.9.x


Date:  Thu Aug  2 14:57:53 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/repair
Inspected by:  mohamedb@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29298a
xfstests/030.out.linux - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/030.out.linux.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Golden output is slightly wrong for xfs_repair 2.9.2+

xfstests/122 - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/122.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Update test for xfs_metablock_t structure
