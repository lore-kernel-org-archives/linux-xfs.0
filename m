Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:53:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5r8HV019813
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:53:13 -0800
Subject: TAKE 976039 - xfs_info can't handle mount points with spaces
Message-Id: <20080121055324.1174D58C4C0F@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 16:53:23 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfs_info handle mount points with spaces


Date:  Mon Jan 21 16:53:01 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30386a
xfsprogs/growfs/xfs_info.sh - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/growfs/xfs_info.sh.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Make xfs_info handle mount points with spaces
