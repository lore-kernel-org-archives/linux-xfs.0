Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 19:34:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB13YGaG029130
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 19:34:17 -0800
Subject: TAKE 958736 - cleanup old 5.3/6.1 log items - from Eric
Message-Id: <20061201033321.4F8B658FF58C@chook.melbourne.sgi.com>
Date: Fri,  1 Dec 2006 14:33:21 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Get rid of old 5.3/6.1 v1 log items.
Cleanup patch sent in by Eric Sandeen.
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Fri Dec  1 14:31:05 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  tes@sgi.com,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27596a
fs/xfs/xfs_buf_item.h - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.h.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- Get rid of old 5.3/6.1 v1 log items.
	  Cleanup patch sent in by Eric Sandeen.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_log_recover.c - 1.314 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.314&r2=text&tr2=1.313&f=h
	- Get rid of old 5.3/6.1 v1 log items.
	  Cleanup patch sent in by Eric Sandeen.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

fs/xfs/xfs_trans.h - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
	- Get rid of old 5.3/6.1 v1 log items.
	  Cleanup patch sent in by Eric Sandeen.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
