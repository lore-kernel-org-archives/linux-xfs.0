Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KFE3fv235198 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 10:14:03 -0500
Subject: Re: [PATCH 1/4] xfs: use a cursor for bulk AIL insertion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110720001530.GA13475@infradead.org>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-2-git-send-email-david@fromorbit.com>
	<1311116624.1964.38.camel@doink> <20110719233644.GB9359@dastard>
	<20110720001530.GA13475@infradead.org>
Date: Wed, 20 Jul 2011 10:13:55 -0500
Message-ID: <1311174835.2906.5.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-07-19 at 20:15 -0400, Christoph Hellwig wrote:
> On Wed, Jul 20, 2011 at 09:36:44AM +1000, Dave Chinner wrote:
> > Looks cleaner, but I'll need to test it. Right now all my test
> > resources are busy with non-mainline stuff, so it's going to be next
> > week sometime before I can do this.
> 
> Given that the merge window is about to open how about putting in the
> current version for now and doing a cleanup patch on top later on?
> 

Will do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
