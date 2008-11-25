Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP0klF4026360 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 18:46:47 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 6D057AC018
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 16:46:43 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA27553 for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 11:46:42 +1100
Subject: TAKE - xfstests: fix buffer overflow in lstat64.c
Message-Id: <20081125004642.0054358C8A4D@chook.melbourne.sgi.com>
Date: Tue, 25 Nov 2008 11:46:41 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Change mode string variable declaration


Date:  Tue Nov 25 11:45:58 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32533a
xfstests/src/lstat64.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/lstat64.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Change mode string variable declaration


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
