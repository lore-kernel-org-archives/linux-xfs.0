Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n45HanXD039450 for <xfs@oss.sgi.com>; Tue, 5 May 2009 12:36:49 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78756AC010
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 10:36:49 -0700 (PDT)
Received: from eagdhcp-232-196.americas.sgi.com
	(eagdhcp-232-196.americas.sgi.com [128.162.232.196])
	by estes.americas.sgi.com (Postfix) with ESMTP id 023877000103
	for <xfs@oss.sgi.com>; Tue,  5 May 2009 12:36:49 -0500 (CDT)
Message-Id: <A6A9C271-5B59-451F-A4CE-EC63BADDDEB7@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: xfsprogs 3.0.1 source tarball released
Date: Tue, 5 May 2009 12:36:48 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.0.1.tar.gz

This version contains important bug fixes and improvements
to xfsprogs 3.0.0:

xfsprogs-3.0.1 (4 May 2009)
         - Update the Makepkgs script to generate proper source  
tarballs.
         - New project(5) and projid(5) man pages.
         - Fix extent array reallocation in the xfs_io bmap command,
           thanks to Tomasz Majkowski.
         - Small specfile improvements, thanks to Jan Engelhardt.
         - Allow xfs_freeze to freeze non-XFS filesystems.
         - Fix the xfs_db bmbta command.
         - Fix parallel builds, thanks to Mike Frysinger.
         - Various autoconf/libtool fixes, thanks to Andreas  
Gruenbacher.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
