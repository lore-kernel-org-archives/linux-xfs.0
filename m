Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HGA3Ul146536 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 11:10:14 -0500
Received: from mail.isg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 323C722164E
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 09:09:47 -0700 (PDT)
Received: from mail.isg.de (rzfoobar.is-asp.com [217.11.194.155]) by
	cuda.sgi.com with ESMTP id B7zvDU7vtgH3Rcgv for
	<xfs@oss.sgi.com>; Fri, 17 Apr 2009 09:09:47 -0700 (PDT)
Message-ID: <49E8A9C8.5030705@isg.de>
Date: Fri, 17 Apr 2009 18:09:44 +0200
From: Peter Niemayer <niemayer@isg.de>
MIME-Version: 1.0
Subject: Re: XFS support for TRIM / blkdev_issue_discard?
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<49E4A131.5040309@isg.de>
	<BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
In-Reply-To: <BB5058FD-E69F-4254-9548-82CD634C7FD6@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

Update: In a recent forum entry
  ( http://www.ocztechnologyforum.com/forum/showthread.php?t=54379&page=11 )
Mark Lord (the maintainer of the "hdparm" tool) states that according
to his tests the newly added support for discarding sectors works in
the Linux "ext4" filesystem.
(Support in GFS2 and swap filesystems has already been available before).

Isn't that another good reason enable XFS to do that, too? :-)

Regards,

Peter Niemayer


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
