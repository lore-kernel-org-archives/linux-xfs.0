Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLNFCp030972 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:23:16 -0600
Date: Fri, 12 Feb 2010 16:24:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dmapi: digitally sign release tags
Message-ID: <20100212212431.GC6084@infradead.org>
References: <201002122058.o1CKwTq6025739@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002122058.o1CKwTq6025739@stout.americas.sgi.com>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 02:58:29PM -0600, Alex Elder wrote:
> Arrange for the commit marking a new release to include a
> "Signed-off-by" line, and have the corresponding tag include
> a digital signature.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

If you start carding about dmapi there are a lot of build system updates
that it still needs to pick up from xfsprogs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
