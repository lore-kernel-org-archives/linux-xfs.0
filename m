Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p66NqQ8K025210 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 18:52:26 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BC221E5C66B
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2011 16:52:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yJoXBUZjjLYRFZIj for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2011 16:52:21 -0700 (PDT)
Date: Thu, 7 Jul 2011 09:52:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706235217.GA1026@dastard>
References: <4E12A927.9020102@gmail.com> <20110705130932.GF1026@dastard>
	<4E1313C1.6020309@gmail.com> <20110706040403.GW1026@dastard>
	<20110706070756.GA25800@infradead.org>
	<20110706072221.GZ1026@dastard>
	<4E14B7EE.2060005@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E14B7EE.2060005@hardwarefreak.com>
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

On Wed, Jul 06, 2011 at 02:30:54PM -0500, Stan Hoeppner wrote:
> On 7/6/2011 2:22 AM, Dave Chinner wrote:
> 
> > log on a 2-disk RAID0 mirror.....
> 
> Is that a typo Dave or a configuration I just hadn't heard of?  Or did
> you intend a slash between RAID0/mirror meaning either/or?

typo - should say RAID1 mirror.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
