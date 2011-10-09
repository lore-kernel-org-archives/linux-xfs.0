Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99F8k1r108338 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 10:08:46 -0500
Date: Sun, 9 Oct 2011 11:08:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH,v2] xfstests: simplify TRIM_OFF_LEN() in "ltp/fsx.c"]
Message-ID: <20111009150845.GB22401@infradead.org>
References: <1318027284.2810.81.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318027284.2810.81.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Fri, Oct 07, 2011 at 05:41:24PM -0500, Alex Elder wrote:
> Review?

This looks good to me, but I'm rather reluctant to do any cosmetic
work until we have fixed the regression in 091 introduced by the last
round of fsx changes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
