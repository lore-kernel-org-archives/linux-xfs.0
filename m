Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 20:24:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBB4OoiY022127
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 20:24:54 -0800
Subject: PARTIAL TAKE 971186 - kill last 2.4 ifdef leftover
Message-Id: <20071211042456.7758F58C4C34@chook.melbourne.sgi.com>
Date: Tue, 11 Dec 2007 15:24:56 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill last 2.4 ifdef leftover

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Dec 11 15:24:15 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30226a
fs/xfs/xfs.h - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- kill last 2.4 ifdef leftover
