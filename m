Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0U7E8Pp256225 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 01:14:08 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5B9B29BB4C
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 23:16:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ILVHLlWpYLMpRTyd for <xfs@oss.sgi.com>;
	Sat, 29 Jan 2011 23:16:33 -0800 (PST)
Date: Sun, 30 Jan 2011 18:16:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: how to decode metadump info produced by xfs_db, and superblock
	error
Message-ID: <20110130071630.GE21311@dastard>
References: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
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
To: lord worm <cryptopsy@live.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 29, 2011 at 07:25:10PM -0500, lord worm wrote:
> 
> What kind of information is in this file produced by metadump, is it worth reading it somehow?
> 
> I'm trying to first understand what's causing a 'superblock cannot
> be read' error in my XFS after a succesfully dd of the partition
> (dd succeeds in copying to a file, and also restoring, but after
> restoring it cannot mount).

dmesg output when the mount fails?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
