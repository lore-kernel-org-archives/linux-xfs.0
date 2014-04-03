Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D62BA7F98
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 16:32:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7965304053
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:32:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mzfDpm3NcX7w1DjL for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 14:32:12 -0700 (PDT)
Date: Fri, 4 Apr 2014 08:32:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: add a test for unlinked inodes due to O_TMPFILE
Message-ID: <20140403213210.GQ17603@dastard>
References: <20140313101302.996355155@bombadil.infradead.org>
	<20140313101433.608283621@bombadil.infradead.org>
	<20140313112907.GJ4263@dastard>
	<20140403110730.GB26244@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140403110730.GB26244@infradead.org>
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

On Thu, Apr 03, 2014 at 04:07:30AM -0700, Christoph Hellwig wrote:
> Skipping this for now, filtering the repair output properly is going to
> be a lot of work, and I'd rather do a generic unlinked inode list
> recovery test instead of tying it to O_TMPFILE.
> 
> With the first patch already reviewed and the second updated those
> should be ready to apply now.

OK, Thanks for the update.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
