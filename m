Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB9A07F89
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 20:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D71AAC002
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 18:16:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NEZpbdoHmnFD1fcD for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 18:16:05 -0700 (PDT)
Date: Fri, 29 Aug 2014 11:15:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Find hardlinks to a file
Message-ID: <20140829011553.GC20518@dastard>
References: <CAGdUFVa3e7VPcmkn3OvcVenXTCedffXov_YSg427aVvURDRUSg@mail.gmail.com>
	<20140828232915.GV20518@dastard>
	<CAGdUFVab40TkTszE84NMHP+=2z+fD4WFQ+Ejjcz0kdxKtruv6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdUFVab40TkTszE84NMHP+=2z+fD4WFQ+Ejjcz0kdxKtruv6Q@mail.gmail.com>
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
To: Chris Holcombe <xfactor973@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 05:51:15PM -0700, Chris Holcombe wrote:
> So let me ask you this.  Is it possible to transform an inode number
> into a path name with xfs?  That's basically the crux of my problem.

$ man xfs_ncheck

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
