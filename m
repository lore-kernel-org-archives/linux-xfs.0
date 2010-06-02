Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o524Uduh047819 for <xfs@oss.sgi.com>; Tue, 1 Jun 2010 23:30:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D85938D174
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 21:33:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	kJg7tLlwfJlpTQfP for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 21:33:05 -0700 (PDT)
Date: Wed, 2 Jun 2010 14:33:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/17] xfs: remove done roadmap item from
	xfs-delayed-logging-design.txt
Message-ID: <20100602043303.GA7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160858.981686872@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160858.981686872@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:28PM -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/Documentation/filesystems/xfs-delayed-logging-design.txt
> ===================================================================
> --- xfs.orig/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-05-30 12:23:13.223254240 +0200
> +++ xfs/Documentation/filesystems/xfs-delayed-logging-design.txt	2010-05-30 12:23:57.363005673 +0200
> @@ -794,11 +794,6 @@ designed.
>  
>  Roadmap:
>  
> -2.6.35 Inclusion in mainline as an experimental mount option
> -	=> approximately 2-3 months to merge window
> -	=> needs to be in xfs-dev tree in 4-6 weeks
> -	=> code is nearing readiness for review
> -
>  2.6.37 Remove experimental tag from mount option
>  	=> should be roughly 6 months after initial merge
>  	=> enough time to:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
