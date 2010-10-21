Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LK5N0e066276 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 15:05:23 -0500
Received: from andrew.triumf.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C362019608D1
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:06:37 -0700 (PDT)
Received: from andrew.triumf.ca (andrew.triumf.ca [142.90.106.59]) by
	cuda.sgi.com with ESMTP id DxYgTro83rMr8nRe for
	<xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:06:37 -0700 (PDT)
Date: Thu, 21 Oct 2010 13:06:36 -0700 (PDT)
From: Andrew Daviel <advax@triumf.ca>
Subject: Best filesystems ?
In-Reply-To: <19648.27859.799400.168394@tree.ty.sabi.co.uk>
Message-ID: <Pine.LNX.4.64.1010211258070.24449@andrew.triumf.ca>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<19646.55189.843933.481529@tree.ty.sabi.co.uk>
	<20101021020009.GG12506@dastard>
	<19648.27859.799400.168394@tree.ty.sabi.co.uk>
MIME-Version: 1.0
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux XFS <xfs@oss.sgi.com>

On Thu, 21 Oct 2010, Peter Grandi wrote:

> But the ig deal here is that's not something that a filesystem
> targeted at high bandwidth multistreaming loads should be
> optimized for, at least by default.

Has someone documented (recently, and correctly) what filesystems (XFS, 
ext3, ext4, reiser, JFS, VFAT etc.) are best for what tasks (mailboxes, 
database, general computing, video streaming etc.) ?

I messed around with Bonnie etc. a couple of years ago, deciding that XFS 
was better than ext3 for 4Mb mailbox fragments. Later I was quite 
impressed by an early ext4 on FC9, until it bombed. But I don't really 
have the skills to assess properly.


-- 
Andrew Daviel, TRIUMF, Canada

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
