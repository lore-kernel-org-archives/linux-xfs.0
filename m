Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB3747F62
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 12:46:45 -0600 (CST)
Message-ID: <52E6A9A2.1010905@sgi.com>
Date: Mon, 27 Jan 2014 12:46:58 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
References: <201401201822.48520.arekm@maven.pl>
In-Reply-To: <201401201822.48520.arekm@maven.pl>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?UTF-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <arekm@maven.pl>, xfs@oss.sgi.com

Arkadiusz,

Thanks for compiling the list.

The for-3.1.12  Branch created from "a547280... 3.1.11 release"

If there are others you want committed, please let me know.

Thanks
--Rich


The following have been committed from the candidate list
provided by Arkadiusz:


40c65a7... xfs_metadump: Make -F (force) optional
ec3a1f1... xfs_repair: suggest reboot after dangerous repair
8660952... xfsprogs: suggest "-d" option for repair of RO mount
5a8206c... xfs_repair: correct docs for "-t" units
0d5c444... xfs_fsr: fix SWAPEXT failures under selinux
f3d3dae... libxfs: fix root inode handling inconsistencies
cf507b6... xfsprogs: remove xfs_check references from fsck.xfs script & 
manpage
6e2f2d1... xfsprogs: fix resource leak in longform_dir2_rebuild()
ecde3f9... xfs_repair: test for bad level in dir2 node
d299df7... xfs_repair: avoid segfault if reporting progress early in repair
e660c2e... Sent: Friday, October 11, 2013 12:38:11 AM Subject: 
Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
5e1c7ac... xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
aba6204... xfsprogs: fix return value of verify_set_primary_sb()
a2ea195... xfsprogs: fix potential memory leak in verify_set_primary_sb()
3e53939... xfsprogs: fix potential memory leak in repare/sb.c
820b8c2... xfsprogs: avoid array overflow in pf_batch_read()
2a1dcdb... xfs_repair: zero out unused parts of superblocks
982508b... xfsprogs: fix inode crash in xfs_repair
b8890d7... xfsprogs: fix unint var in repair phase6
7d710b9... xfsprogs: fix agcnts leak in xfs_repair's scan_ags
291c159... xfsprogs:free bp in xlog_find_tail() error path
40b9d95... xfsprogs: free bp in xlog_find_zeroed() error path
a9b4757... xfsprogs: fix buffer leak in xlog_print_find_oldest
32aae5b... xfsprogs: avoid double-free in xfs_attr_node_addname
243cf82... mkfs.xfs: fix protofile name create block reservation
b31a23d... xfs_metadump: manpage fix regarding frozen fs
f8b80a3... xfs_fsr: file reads should be O_DIRECT

The following commits were not applicable.
e7c05095, e6efb967 6aa3d87b





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
