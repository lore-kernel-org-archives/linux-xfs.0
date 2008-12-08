Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB81AJgB018404 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 19:10:19 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 9D0FAAC034
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2008 17:10:15 -0800 (PST)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com
	[134.14.55.58]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA04759 for
	<xfs@oss.sgi.com>; Mon, 8 Dec 2008 12:10:13 +1100
Date: Mon, 08 Dec 2008 12:14:11 +1100
Subject: xfsprogs 2.10.2 source tarball released
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
Message-ID: <op.ultkdxb03jf8g2@pc-bnaujok.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.10.2-1.tar.gz

This version contains important bug fixes to xfsprogs 2.10.1:

xfsprogs-2.10.2 (8 December 2008)
	- Fix an mkfs.xfs regression where -i maxpct option was ignored.
	- Fix mkfs.xfs -d agcount and su/sw options when used together.
	- Fix a regression where repaired inodes in xfs_repair were not
	  written to disk.
	- Allow 64K block size support in xfs_repair.
	- Fix up unaligned accesses in 64 bit platforms in xfs_repair.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
