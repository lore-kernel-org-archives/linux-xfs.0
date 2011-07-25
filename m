Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PGRJcS011748 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:27:19 -0500
Date: Mon, 25 Jul 2011 12:27:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
Message-ID: <20110725162718.GC2434@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110724113959.GD26332@infradead.org>
	<1311609452.2914.23.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311609452.2914.23.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, Jul 25, 2011 at 10:57:32AM -0500, Alex Elder wrote:
> Christoph, are you suggesting that this one hunk just
> be excluded from the series?  Or the entire patch?

There's not much more in this patch, so I would suggest dropping it
entirely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
