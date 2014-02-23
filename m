Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBA8F7F57
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 15:01:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE1B88F8035
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 13:01:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	d5qEqGdb4oYbiXGN for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 13:01:19 -0800 (PST)
Date: Mon, 24 Feb 2014 08:01:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140223210114.GB4317@dastard>
References: <20140220220000.GA17541@infradead.org>
	<20140221003014.GA23416@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140221003014.GA23416@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 04:30:15PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 20, 2014 at 02:00:00PM -0800, Christoph Hellwig wrote:
> Add a new -T argument to the open command that supports using the
> O_TMPFILE flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
