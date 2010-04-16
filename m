Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3GH2TLN261637 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 12:02:31 -0500
Date: Fri, 16 Apr 2010 13:04:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: change a few labels in xfs_log_recover.c
Message-ID: <20100416170425.GA2729@infradead.org>
References: <1271355446.2680.86.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1271355446.2680.86.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Thu, Apr 15, 2010 at 01:17:26PM -0500, Alex Elder wrote:
> Rename a label used in xlog_find_head() that I thought was poorly
> chosen.  Also combine two adjacent labels xlog_find_tail() into
> a single label, and give it a more generic name.
> 
> (Now using Dave's suggested "validate_head" name for first label.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
