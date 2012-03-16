Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2G7Ypri027066 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 02:34:51 -0500
Received: from mr.tuwien.ac.at (mr2.kom.tuwien.ac.at [128.130.2.110]) by
	cuda.sgi.com with ESMTP id idsnsI5zEYJoMrBv for
	<xfs@oss.sgi.com>; Fri, 16 Mar 2012 00:34:49 -0700 (PDT)
Received: from localhost (webmail.tuwien.ac.at [128.130.35.72])
	by mr.tuwien.ac.at (8.13.7/8.13.7) with ESMTP id q2G7YmeM011691
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 08:34:48 +0100 (MET)
Message-ID: <20120316083401.37063vtvgebrbyzt@webmail.tuwien.ac.at>
Date: Fri, 16 Mar 2012 08:34:01 +0100
From: Michael Weingartner <michael.weingartner@tuwien.ac.at>
Subject: xfs on 13 TB Storage
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear Ladies and Gentlemen,

Recently I upgraded ubuntu server from 8.04 to 10.04 32(bit).
I use two HP MAS60 with E500 Controller.

There was never a Problem with a xfs file system.

Yesterday I received:

Filesystem "cciss/c0d0p1":XFS internal error xfs_trans_cancel at line  
1731 of file  
/build/buildd/linx-lts-backport-maverick-2.6.35/fs/xfs/xfs_trans.c  
Caller 0xf917d8b8

Any ideas?

with kind regards
mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
