Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HGrBKv148200 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 11:53:22 -0500
Message-ID: <49E8B36E.1080508@sandeen.net>
Date: Fri, 17 Apr 2009 11:50:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>	<49E4A131.5040309@isg.de>	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
	<49E8A9C8.5030705@isg.de>
In-Reply-To: <49E8A9C8.5030705@isg.de>
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
To: Peter Niemayer <niemayer@isg.de>
Cc: xfs@oss.sgi.com

Peter Niemayer wrote:
> Update: In a recent forum entry
>   ( http://www.ocztechnologyforum.com/forum/showthread.php?t=54379&page=11 )
> Mark Lord (the maintainer of the "hdparm" tool) states that according
> to his tests the newly added support for discarding sectors works in
> the Linux "ext4" filesystem.
> (Support in GFS2 and swap filesystems has already been available before).
> 
> Isn't that another good reason enable XFS to do that, too? :-)

I don't think anyone disagrees that it's a good idea; it's a question of
resources and priorities, is all.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
