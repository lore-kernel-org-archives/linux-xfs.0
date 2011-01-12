Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CCHbJM187879 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 06:17:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93C3E1256C14
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 04:19:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	H5yyR5Qfz0kEMnRq for <xfs@oss.sgi.com>;
	Wed, 12 Jan 2011 04:19:48 -0800 (PST)
Date: Wed, 12 Jan 2011 23:19:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/12] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20110112121946.GD16267@dastard>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-2-git-send-email-david@fromorbit.com>
	<20110112121010.GA32321@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110112121010.GA32321@infradead.org>
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

On Wed, Jan 12, 2011 at 07:10:10AM -0500, Christoph Hellwig wrote:
> Looks good.  I think this patch also still is a candidate for 2.6.38,
> while the rest looks more like 2.6.39 material.

Agreed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
