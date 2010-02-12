Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLptF3034492 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:51:55 -0600
Subject: Re: [PATCH] xfsprogs: eliminate some build warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100212212622.GE6084@infradead.org>
References: <201002122105.o1CL51p4026682@stout.americas.sgi.com>
	<20100212212622.GE6084@infradead.org>
Date: Fri, 12 Feb 2010 15:53:06 -0600
Message-ID: <1266011586.1865.16.camel@doink1>
Mime-Version: 1.0
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

On Fri, 2010-02-12 at 16:26 -0500, Christoph Hellwig wrote:
> 
> Except for the db/check.c hunks these are files shared with the
> kernel,
> and changes should be done to the kernel files first and then
> resynced.
> I've started a resync of the kernel code with libxfs, but it's
> actually
> a lot of work, mostly due to the tracing changes on the kernel side. 

OK, I'll re-submit without those libxfs changes shortly,
and will wait for you (or someone else) to do it right.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
