Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L58lHR188631 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 00:08:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F9A9F3C414
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 22:25:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	g1bQ8yEri6NUe3Fi for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 22:25:03 -0700 (PDT)
Date: Thu, 21 Oct 2010 16:09:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdocs-xml: fix various formatting errors
Message-ID: <20101021050949.GQ32255@dastard>
References: <20101008094412.GA7118@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101008094412.GA7118@infradead.org>
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
Cc: Turbo Fredriksson <turbo@bayour.com>, xfs@oss.sgi.com

On Fri, Oct 08, 2010 at 05:44:12AM -0400, Christoph Hellwig wrote:
> 
> Fix up a few formatting errors pointed out by Turbo Fredriksson, and while
> at it also remove various non-ASCII characters that sneaked in during the
> initial conversion
> 
> Reported-by: Turbo Fredriksson <turbo@bayour.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

looks good to me, but one minor change still needed....

Reviewed-by: Dave Chinner <david@fromorbit.com>

> @@ -200,9 +200,9 @@ re-running xfs_repair. If you are unable
>  the -L option to destroy the log and attempt a repair.
>  Note that destroying the log may cause corruption -- please attempt a mount
>  of the filesystem before doing this.</programlisting></para>
> -		<para>Usefulinformationcanbecollectedfortriage:</para>
> +		<para>Useful information can becollected for triage:</para>
                                             be collected

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
