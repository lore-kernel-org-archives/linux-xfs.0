Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8S1fiIn214269 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 20:41:47 -0500
Date: Mon, 27 Sep 2010 21:42:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/18] xfs: metadata scalability V4
Message-ID: <20100928014239.GA9039@infradead.org>
References: <1285552073-14663-1-git-send-email-david@fromorbit.com>
	<1285609947.2380.70.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285609947.2380.70.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 27, 2010 at 12:52:27PM -0500, Alex Elder wrote:
> On Mon, 2010-09-27 at 11:47 +1000, Dave Chinner wrote:
> > xfs: Metadata scalability patchset V4
> 
> As far as I'm concerned I'm prepared to pull this series
> in whenever you send a request.  Nice work.

I'm also fine with the series.  Together with the projid32 patches we
should be mostly set for .37.

Can you please make sure we get the CIL push fix into .36 ASAP, too?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
