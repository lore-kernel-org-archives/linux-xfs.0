Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7Vr38007179 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:31:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B69515F9C05
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:34:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	mwTN2T2fBpyyuIZm for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:34:51 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:34:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: fix gcc 4.6 set but not read and unused
	statement warnings
Message-ID: <20100720073445.GF32635@dastard>
References: <20100718203848.927859114@bombadil.infradead.org>
	<20100718203925.908589529@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718203925.908589529@bombadil.infradead.org>
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
Cc: Andi Kleen <ak@linux.intel.com>, xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 04:38:49PM -0400, Christoph Hellwig wrote:
> [hch: dropped a few hunks that need structural changes instead]
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
