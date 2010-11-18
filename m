Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI5hWwX127295 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 23:43:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DDC713D102D
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 21:45:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	YUCD43A2sEzHSLJF for <xfs@oss.sgi.com>;
	Wed, 17 Nov 2010 21:45:04 -0800 (PST)
Date: Thu, 18 Nov 2010 16:44:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix 108 golden output
Message-ID: <20101118054456.GV13830@dastard>
References: <20101110125855.GA18357@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101110125855.GA18357@infradead.org>
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

On Wed, Nov 10, 2010 at 07:58:55AM -0500, Christoph Hellwig wrote:
> The new common scratch mount filter produces slightly different
> whitespaces than the old home grown filter, so adjust the golden
> output.

I'm not seeing it fail with the new filter, so I'm not sure whether
there's a whitespace problem. The userspace i just tested on is
3.1.2, maybe there's something different at your end?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
