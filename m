Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6K0Oc0d060187 for <xfs@oss.sgi.com>; Thu, 19 Jul 2012 19:24:39 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BZAoFYXJqltqyKTf for <xfs@oss.sgi.com>;
	Thu, 19 Jul 2012 17:24:37 -0700 (PDT)
Date: Fri, 20 Jul 2012 10:24:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Xfstests/254: add more cases for testing btrfs snapshot
	in 254
Message-ID: <20120720002433.GH23387@dastard>
References: <5007E0FB.9040208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5007E0FB.9040208@cn.fujitsu.com>
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
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2012 at 06:27:07PM +0800, Liu Bo wrote:
> From: Zhou Bo <zhoub-fnst@cn.fujitsu.com>
> 
> This patch adds more cases in 254 for testing btrfs snapshot.
> 
> Signed-off-by: Zhou Bo <zhoub-fnst@cn.fujitsu.com>

I think it is better to create a new test than modify the old one.
That way it is easy to tell the difference between a new failure and
regression.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
