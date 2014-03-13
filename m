Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 440E47F87
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 05:21:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6642AC002
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 03:21:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	I8Ma2g8ycvzb2aYW for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 03:21:10 -0700 (PDT)
Date: Thu, 13 Mar 2014 21:21:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs_io: add support for flink
Message-ID: <20140313102108.GG4263@dastard>
References: <20140220220000.GA17541@infradead.org>
	<20140221004933.GA9445@infradead.org>
	<20140225195218.GA14110@infradead.org>
	<20140225233556.GI13647@dastard>
	<20140313100933.GA25703@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140313100933.GA25703@infradead.org>
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

On Thu, Mar 13, 2014 at 03:09:33AM -0700, Christoph Hellwig wrote:
> On Wed, Feb 26, 2014 at 10:35:57AM +1100, Dave Chinner wrote:
> > Looks like some noise got into that hunk. Other than that:
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > I'll remove that extra line when I commit it.
> 
> ping?

Sorry, I missed them in the last round of commits. I'll sort it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
