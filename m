Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p148XLrR002509 for <xfs@oss.sgi.com>; Fri, 4 Feb 2011 02:33:22 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85E931BC9D22
	for <xfs@oss.sgi.com>; Fri,  4 Feb 2011 00:35:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7717dAvTDACp0DtZ for <xfs@oss.sgi.com>;
	Fri, 04 Feb 2011 00:35:50 -0800 (PST)
Date: Fri, 4 Feb 2011 19:35:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs undelete issue
Message-ID: <20110204083547.GX11040@dastard>
References: <201102040530.36244.serhan.danis@yahoo.com.tr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201102040530.36244.serhan.danis@yahoo.com.tr>
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
To: Serhan Danis <serhan.danis@yahoo.com.tr>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Fri, Feb 04, 2011 at 05:30:36AM +0200, Serhan Danis wrote:
> 
> Hello,
> 
> I want to get some advice from you about some lost files. A user has 
> indeliberatly deleted some common files managed by a samba server on an xfs 
> filesystem. I want to undelete these files if possible. I have used the 
> testdisk and its file management tool before, but this time the problem is 
> that the partition has 443 G of data used. It would be extremely hard to pick 
> the lost files from a vast bunch of data.  
> 
> What would you recommend for this issue ? Thank you.

Restore from backups.

Also, Asking on the XFS list would be a good start - this is a
FAQ.  CC'd the XFS list so people can tell you their tails of
recovery.

Finally:

http://xfs.org/index.php/XFS_FAQ#Q:_Does_the_filesystem_have_an_undelete_capability.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
