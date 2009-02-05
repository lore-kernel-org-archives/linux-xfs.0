Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n150KYpA180320 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 18:20:34 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87423AC012
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:19:52 -0800 (PST)
Received: from eagdhcp-232-197.americas.sgi.com
	(eagdhcp-232-197.americas.sgi.com [128.162.232.197])
	by estes.americas.sgi.com (Postfix) with ESMTP id B2DE17000103
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 18:19:51 -0600 (CST)
Message-Id: <86FA5963-93E1-4BB6-ACC1-70D1628CB926@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: xfsprogs 3.0.0 source tarball released
Date: Wed, 4 Feb 2009 18:19:51 -0600
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
To: xfs@oss.sgi.com

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.0.0.tar.gz

This version contains important bug fixes and improvements
to xfsprogs 2.10.2:

xfsprogs-3.0.0 (4 February 2009)
         - Various smaller xfs_repair improvements.
         - Various gettext improvements, thanks to Jakub Bogusz.
         - Polish translation update, thanks to Jakub Bogusz.
         - Various xfs_quota fixes, thanks to Arkadiusz Miskiewicz.
         - Support parallel builds.
         - Detection of btrfs, gfs and gfs2 in libdisk.
         - Addition of the xfs_fsr and xfs_estimate tools previous found
           in the xfsdump package.
         - Resync libxfs to latest kernel implemenation.
         - Update all of xfsprogs to latest kernel interfaces.
         - Add sparse support to xfsprogs build.
         - Cleanup devel package for xfsctl, libhandle and libdisk only
           (remove libxfs interfaces).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
