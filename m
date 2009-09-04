Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n84ErPCh216643 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 09:53:42 -0500
Date: Fri, 4 Sep 2009 10:51:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/14] repair memory usage reductions
Message-ID: <20090904145109.GA8351@infradead.org>
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090903204940.GB24510@sgi.com>
	<20090904025753.GB7146@discord.disaster>
	<20090904133737.GD12052@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090904133737.GD12052@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Sep 04, 2009 at 08:37:37AM -0500, Geoffrey Wehrman wrote:
> On Fri, Sep 04, 2009 at 12:57:53PM +1000, Dave Chinner wrote:
> | Christoph asked me to repeat what I said on #xfs w.r.t the regression.
> 
> Thank you for the detailed description.  All I had was a statement from
> January 2008, "Barry has completed the memory optimization, but initial
> testing shows that performance has regressed."  That was the last update
> recorded on Barry's work.
> 
> | With that in mind, I think the memory usage optimisation is far more
> | important to the majority of XFS users than the CPU usage regression
> | it causes as the majority of users don't have RAM-rich environments
> | to run repair in.
> 
> I agree.

In my testing I haven't seen big differences in performance, it
sometimes got a bit faster and sometimes a bit slower.  I will send out
a more detailed performace report in a few days.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
