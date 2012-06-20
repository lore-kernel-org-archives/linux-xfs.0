Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KGZwAo107228 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 11:35:58 -0500
Date: Wed, 20 Jun 2012 11:36:08 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] types.h: implement intptr_t and uintptr_t
Message-ID: <20120620163608.GA10196@sgi.com>
References: <1338487534-14575-1-git-send-email-jengelh@inai.de>
	<20120620075216.GA24798@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620075216.GA24798@infradead.org>
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
Cc: joe@perches.com, Jan Engelhardt <jengelh@inai.de>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Christoph,

On Wed, Jun 20, 2012 at 03:52:16AM -0400, Christoph Hellwig wrote:
> I'd really like to get Jans type cleanups in XFS in for the next
> merge window.  Given the lack of feedback on lkml in favor or
> against (u)intptr_t I'm tempted to add them to xfs_linux.h for now,
> and then do another push to propagate them to kernel-wide types later.
> 
> Is that fine with everybody?

That's fine with me.  But maybe there will be some feedback.  There is still
some time before the merge window.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
