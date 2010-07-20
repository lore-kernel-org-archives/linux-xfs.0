Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7m2o6008043 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:48:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DD3D45A93F
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:51:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	YHianFWroWhp4Ke4 for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:51:01 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:50:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] a few cleanups for 2.6.36
Message-ID: <20100720075059.GL32635@dastard>
References: <20100718203848.927859114@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718203848.927859114@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 04:38:48PM -0400, Christoph Hellwig wrote:
> A couple of random cleanups, including those hunks from Andi's gcc 4.6
> warning fixes that can easily be applied.

I'm running QA on this series plus all the other outstanding
patches. I'll push those out into a branch when that is done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
