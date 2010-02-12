Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLqQHP034571 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:52:26 -0600
Subject: Re: [PATCH] xfsprogs: fix some warnings
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100212212329.GA6084@infradead.org>
References: <201002122049.o1CKnjAf024589@stout.americas.sgi.com>
	<20100212212329.GA6084@infradead.org>
Date: Fri, 12 Feb 2010 15:53:40 -0600
Message-ID: <1266011620.1865.17.camel@doink1>
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

On Fri, 2010-02-12 at 16:23 -0500, Christoph Hellwig wrote:
> On Fri, Feb 12, 2010 at 02:49:45PM -0600, Alex Elder wrote:
> > Fix a couple of build warnings.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > ---
> >  ltp/fsx.c    |    2 +-
> >  src/loggen.c |    1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Looks good, but it's actually for xfstests, not xfsdump as said in
> the subject line.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I will fix the subject line before I commit.
Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
