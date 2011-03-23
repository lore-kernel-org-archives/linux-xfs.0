Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2NCEXQI091163 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:14:43 -0500
Date: Wed, 23 Mar 2011 08:17:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: do not immediately reuse busy extent ranges
Message-ID: <20110323121733.GC468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.474878707@bombadil.infradead.org>
	<1300833059.2875.276.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1300833059.2875.276.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 22, 2011 at 05:30:59PM -0500, Alex Elder wrote:
> Again, this looks nearly identical to your last version.
> On that one, I suggested rewording a comment, and you
> said "ok."  You did not do so in this version, which I
> guess is fine.  I just want to know whether you intended
> to.  If so I'll give you a chance to post an update; if
> not I can take this one as-is.

Sorry, I fixe half of what you pointed out and postponed the
comment rewrite.  I've taken your version of the comments
for the next spin.  Still not sure what to do about the magic 4,
though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
