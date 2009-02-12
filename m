Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CLtov6087336 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 15:55:50 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ACA818E83D6
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:55:13 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	zBtbMM0E0gycZXD0 for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2009 13:55:13 -0800 (PST)
Date: Fri, 13 Feb 2009 08:55:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: soft lockup detected on CPU#1!
Message-ID: <20090212215508.GT8830@disturbed>
References: <alpine.DEB.1.10.0902111835420.27406@p34.internal.lan>
	<235313.30733.qm@web30205.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <235313.30733.qm@web30205.mail.mud.yahoo.com>
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
To: raksac@yahoo.com
Cc: xfs@oss.sgi.com

On Thu, Feb 12, 2009 at 01:22:16AM -0800, raksac@yahoo.com wrote:
> 
> Hi Justin,
> 
> Yes it is a 2.6.18 rhel5 based custom kernel but the
> XFS driver is a back port from the 2.6.28.4

Then you get to keep all the broken bits to yourself.  If you want
to throw random versions of XFS at random versions of kernels then
we can't help you - we don't have the time or resources to support
random backports of XFS to older kernels (and non-vanilla kernels
at that).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
