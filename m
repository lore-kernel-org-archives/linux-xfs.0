Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:20:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491JpJG007951
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:19:53 -0700
Subject: PARTIAL TAKE 981498 - Remove unused flags parameter from xfs_qm_dqpurge
Message-Id: <20080509012026.1309558C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:20:26 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove unused flags parameter from xfs_qm_dqpurge()

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Date:  Fri May  9 11:19:40 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31056a
fs/xfs/quota/xfs_dquot.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- remove unused flag parameter from xfs_qm_dqpurge.

fs/xfs/quota/xfs_dquot.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- remove unused flag parameter from xfs_qm_dqpurge.

fs/xfs/quota/xfs_qm.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- remove unused flag parameter from xfs_qm_dqpurge.
