Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 969317F72
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 22:20:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E3B6304032
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 20:20:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	se2BGpcyGVRTSNoY for <xfs@oss.sgi.com>;
	Mon, 27 Jan 2014 20:20:28 -0800 (PST)
Date: Tue, 28 Jan 2014 15:20:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
Message-ID: <20140128042024.GH2212@dastard>
References: <201401201822.48520.arekm@maven.pl>
 <52E6A9A2.1010905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E6A9A2.1010905@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 27, 2014 at 12:46:58PM -0600, Rich Johnston wrote:
> Arkadiusz,
> 
> Thanks for compiling the list.
> 
> The for-3.1.12  Branch created from "a547280... 3.1.11 release"
> 
> If there are others you want committed, please let me know.

What testing have you done on the branch?

> 40c65a7... xfs_metadump: Make -F (force) optional
> ec3a1f1... xfs_repair: suggest reboot after dangerous repair
> 8660952... xfsprogs: suggest "-d" option for repair of RO mount
> 5a8206c... xfs_repair: correct docs for "-t" units
> 0d5c444... xfs_fsr: fix SWAPEXT failures under selinux
> f3d3dae... libxfs: fix root inode handling inconsistencies
> cf507b6... xfsprogs: remove xfs_check references from fsck.xfs
> script & manpage
> 6e2f2d1... xfsprogs: fix resource leak in longform_dir2_rebuild()
> ecde3f9... xfs_repair: test for bad level in dir2 node
> d299df7... xfs_repair: avoid segfault if reporting progress early in repair
> e660c2e... Sent: Friday, October 11, 2013 12:38:11 AM Subject:
> Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64

Can you fix the subject line of this commit, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
