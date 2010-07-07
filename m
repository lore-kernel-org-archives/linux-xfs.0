Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o676XlCK224442 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 01:33:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B035159879C
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 23:36:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	w26zLUpYKmmE0gSU for <xfs@oss.sgi.com>;
	Tue, 06 Jul 2010 23:36:36 -0700 (PDT)
Date: Wed, 7 Jul 2010 16:36:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs file system in process of becoming corrupt;	though
	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
Message-ID: <20100707063634.GI25018@dastard>
References: <20100628022744.GX6590@dastard> <4C2A749E.4060006@tlinx.org>
	<20100629232532.GA24712@dastard> <4C2A87FF.7090804@dermichi.com>
	<4C2A92DA.1020202@tlinx.org> <20100630011647.GD24712@dastard>
	<4C2AAFC1.9080708@tlinx.org> <20100701235802.GW24712@dastard>
	<4C33F20F.4040905@tlinx.org> <4C341712.5030202@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C341712.5030202@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 06, 2010 at 10:56:34PM -0700, Linda Walsh wrote:
> For what it's worth, my 'undeletable' files give every appearance of
> being 'plain' UTF-8 encoded file names.  Wrote a perl script that looped
> through and used the 'bytes' pragma to look at the bytes.  Looks like
> valid UTF-8.  Also had it try to remove the files.  Didn't work.

Can you send me a link to a metadump image of the filesystem so I can
look at the broken directories in detail?

Cheers.

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
