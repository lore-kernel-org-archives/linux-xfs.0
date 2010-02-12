Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLMEaD030844 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:22:14 -0600
Date: Fri, 12 Feb 2010 16:23:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix some warnings
Message-ID: <20100212212329.GA6084@infradead.org>
References: <201002122049.o1CKnjAf024589@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002122049.o1CKnjAf024589@stout.americas.sgi.com>
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

On Fri, Feb 12, 2010 at 02:49:45PM -0600, Alex Elder wrote:
> Fix a couple of build warnings.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  ltp/fsx.c    |    2 +-
>  src/loggen.c |    1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)

Looks good, but it's actually for xfstests, not xfsdump as said in
the subject line.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
