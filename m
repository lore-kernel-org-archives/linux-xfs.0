Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CIxxtJ077789 for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 13:00:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4BC2117CDE
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:59:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VoxbgvJ1r2tm9MJD for
	<xfs@oss.sgi.com>; Thu, 12 Feb 2009 10:59:24 -0800 (PST)
Date: Thu, 12 Feb 2009 13:58:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, needs a new owner] XFS Alloc Policies
Message-ID: <20090212185853.GA23056@infradead.org>
References: <49939F90.20905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49939F90.20905@sgi.com>
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
To: Mark Goodwin <goodwinos@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 12, 2009 at 03:03:28PM +1100, Mark Goodwin wrote:
>
> Series of patches, originally by Dave Chinner. This series
> of 18 patches is unfinished and needs a new owner - the
> feature partially implements pluggable allocation policies
> for XFS.
>
> A fairly substantial architectural write-up with community
> debate/feedback on the design would be appropriate before
> embarking on this. Tarball attached for the following:

Thanks for posting these.  I'm pretty sure these patches will
get some sort of makeover before beeing ready, but they are
an important building block for some of the interesting work
we're planning to do (like the multi device work or ssd-aware
allocators), so there will be some action on it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
