Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6K0FYYY200556 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 19:15:35 -0500
Date: Tue, 19 Jul 2011 20:15:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110720001530.GA13475@infradead.org>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-2-git-send-email-david@fromorbit.com>
	<1311116624.1964.38.camel@doink> <20110719233644.GB9359@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110719233644.GB9359@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

On Wed, Jul 20, 2011 at 09:36:44AM +1000, Dave Chinner wrote:
> Looks cleaner, but I'll need to test it. Right now all my test
> resources are busy with non-mainline stuff, so it's going to be next
> week sometime before I can do this.

Given that the merge window is about to open how about putting in the
current version for now and doing a cleanup patch on top later on?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
