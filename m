Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SI1IMr130162 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 13:01:18 -0500
Date: Tue, 28 Aug 2012 14:02:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120828180207.GA18356@infradead.org>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com> <20120824040724.GA19235@dastard>
	<20120828174304.GB3274@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828174304.GB3274@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Aug 28, 2012 at 12:43:04PM -0500, Ben Myers wrote:
> I got the impression that Christoph is doing a review of this patch set as
> well.  If you wait for Christoph's review before moving bench it will give Phil
> a little time to come up with a plan for discussion.

I'll try to get to it quickly.  I shared Dave's opinion on the current
bench code, but I also agree that if SGI has it in use right now we
can't remove it.  I'm still not quite clear if you guys use it right now
or just maybe plan to use it real soon.  If it's the latter I'd be in
favour of removing it, if not we must keep it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
