Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q228fR4v018345 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 02:41:27 -0600
Date: Fri, 2 Mar 2012 03:41:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: time for userspace releases?
Message-ID: <20120302084123.GA19172@infradead.org>
References: <20120112161227.GA3225@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112161227.GA3225@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Jakub Bogusz <qboosh@pld-linux.org>

On Thu, Jan 12, 2012 at 11:12:27AM -0500, Christoph Hellwig wrote:
> [looks like the list manager ate this mail the first time, sorry if
>  anyone gets it twice]
> 
> We have some important repair fixes pending, as well as major changes
> in xfsdump.  Maybe it's time to schedule releases in about two weeks
> and get any outstanding changes in?

We've dragged this out another 1 1/2 month, so let's get the ball
rolling.  I'd like to declare today feature and string freeze for
xfsprogs 3.1.8, and once Jakub has sent in the translations get it
out.  We should try to get a 3.1.9 out relatively soon after that as
there is lots more repair work pending, as well as the userspace support
for separate group and project quotas.  If we aim for a 2 to 3 month
release cycle we should be able to time it for the Linux 3.4 release.

There are no translations for xfsdump, but I'd propose to release it at
the same time.  Given the significant changes I think the xfsdump
version should be bumped to 3.1.0.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
