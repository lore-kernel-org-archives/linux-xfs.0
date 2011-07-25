Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PGQVf6011656 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 11:26:31 -0500
Date: Mon, 25 Jul 2011 12:26:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] xfs: Remove the macro XFS_BUFTARG_NAME
Message-ID: <20110725162629.GB2434@infradead.org>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311364181.2771.114.camel@doink>
	<20110724113724.GC26332@infradead.org>
	<1311609460.2914.25.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311609460.2914.25.camel@doink>
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

On Mon, Jul 25, 2011 at 10:57:40AM -0500, Alex Elder wrote:
> That's an even better idea.  I was only reacting to the
> code in front of me, but yes, removing it entirely
> would be good.
> 
> For now though, I intend to commit this (in its now updated
> form).  It can be removed as a separate patch.

Agreed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
