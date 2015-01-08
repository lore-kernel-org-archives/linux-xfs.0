Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0CE1A7F47
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 17:42:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF862304039
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:42:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	YbpG34Atgdphst1v for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 15:42:18 -0800 (PST)
Date: Fri, 9 Jan 2015 10:24:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: About XFS size in 32/64 bit Linux
Message-ID: <20150108232442.GN25000@dastard>
References: <alpine.LSU.2.11.1501082223080.5948@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1501082223080.5948@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, Jan 08, 2015 at 10:28:52PM +0100, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> Hi,
> 
> I'm about to prepare an XFS partitioned 2TB hard disk in an external
> enclosure (USB/eSATA), using openSUSE 13.1 64 bit, but I intend to
> use it mostly under 13.1 32 bit (kernel 3.11.10)
> 
> Should I expect problems? Something to be aware of? Limits when
> using 32 bit, perhaps?

16TB max fs and file size, otherwise no differences.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
