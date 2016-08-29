Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3585A7CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 20:31:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E88B78F8037
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 18:31:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uQ4jorrbvxcZYTQE for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2016 18:31:13 -0700 (PDT)
Date: Mon, 29 Aug 2016 11:31:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 800b269
Message-ID: <20160829013111.GN19025@dastard>
References: <20160826062508.GG19025@dastard>
	<20160826074844.GA17137@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826074844.GA17137@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 12:48:44AM -0700, Christoph Hellwig wrote:
> Hi Dave,
> 
> please consider: "[PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for
> extent based filesystems"
> 
> for 4.8.  It fixes a regression in the iomap-based fiemap
> implementation, and it's fairly trivial as well.

Oh, damn, I thought I got that one. I'll append it to the
series and push it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
