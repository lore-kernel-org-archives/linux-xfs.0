Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0Q4YK4O114092 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 22:34:21 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21E891A2B3DE
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 20:36:43 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RaEIQbfjWUDhaJaE for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 20:36:43 -0800 (PST)
Date: Wed, 26 Jan 2011 15:36:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: version dependency question
Message-ID: <20110126043640.GA21311@dastard>
References: <4D3F5DA4.3070809@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D3F5DA4.3070809@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 25, 2011 at 05:32:52PM -0600, Stan Hoeppner wrote:
> Is the delaylog fstab mount option dependent on anything external to the kernel,
> such as the mount command, or xfsprogs?  Do these need to be updated to take
> advantage of '-o delaylog'?

No, it's purely a kernel thing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
