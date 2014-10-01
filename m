Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 711127F6A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 18:04:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D812AC011
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:03:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aF4qHAHckOAD5A1x for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 16:03:56 -0700 (PDT)
Date: Thu, 2 Oct 2014 09:03:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20141001230342.GD10298@dastard>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-10-git-send-email-david@fromorbit.com>
	<20140926123338.GA18558@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926123338.GA18558@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 05:33:38AM -0700, Christoph Hellwig wrote:
> Looks good, although I still think this would benefit from a helper
> like the one below (patch lightly tested).
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks. I'll queue the helper patch up for after the next merge
window.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
