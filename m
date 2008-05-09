Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:24:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491NsrH008521
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:23:56 -0700
Subject: PARTIAL TAKE 981498 - Remove unused wbc parameter from xfs_start_page_writeback()
Message-Id: <20080509012436.918CA58C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:24:36 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove unused wbc parameter from xfs_start_page_writeback()

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>


Date:  Fri May  9 11:24:08 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vda.linux@googlemail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31057a
fs/xfs/linux-2.6/xfs_aops.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- Remove unused wbc parameter from xfs_start_page_writeback
