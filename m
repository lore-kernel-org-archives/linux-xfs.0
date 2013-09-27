Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1028C7F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 18:39:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9ACE304053
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 16:39:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DHatN4KKhE0Uux6O for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 16:39:10 -0700 (PDT)
Date: Sat, 28 Sep 2013 09:39:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: make log/size consistent for mkfs's -s option
Message-ID: <20130927233905.GZ26872@dastard>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5245C07A.3000700@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Fri, Sep 27, 2013 at 12:29:30PM -0500, Eric Sandeen wrote:
> (mkfs.xfs is so crufty :(  )

Yes, it needs to go on a massive factoring program....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
