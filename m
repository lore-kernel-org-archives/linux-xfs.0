Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7UMvC0i052453 for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 17:57:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 417628F80CF
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 15:58:08 -0700 (PDT)
Received: from [IPv6???1] (sshgate.corp.sgi.com [198.149.20.12])
	by estes.americas.sgi.com (Postfix) with ESMTP id CDC347000103
	for <xfs@oss.sgi.com>; Sun, 30 Aug 2009 17:55:06 -0500 (CDT)
Message-Id: <69712CC9-EACE-469C-B0C2-6F616C6845B2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: xfsprogs 3.0.3 source tarball released
Date: Sun, 30 Aug 2009 17:55:04 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Development <xfs@oss.sgi.com>

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.0.3.tar.gz

This version contains important bug fixes and improvements
to xfsprogs 3.0.2:

xfsprogs-3.0.3 (30 August 2009)
	- Fix unaligned accesses in libxfs.
	- Various small fixes to xfs_db, xfs_repair and xfs_io.
	- Add fallocate command to xfs_io.
	- Enable readline support in xfs_io and xfs_quota.
	- Allow log sizes up to 2GiB (minus 1 byte) in xfs_mkfs.
	- Open the block device in xfs_repair exclusively, thanks to
	  Nathaniel W. Turner.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
