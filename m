Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA38LbGL249663 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 03:21:37 -0500
Date: Thu, 3 Nov 2011 04:21:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfsdump: link with libpthread
Message-ID: <20111103082135.GA11854@infradead.org>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
	<1320268254-20583-2-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320268254-20583-2-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 02, 2011 at 04:10:47PM -0500, Bill Kendall wrote:
> This patch changes xfsdump/xfsrestore to link with libpthread in
> preparation for enabling multi-stream support. The libpthread checks
> are the same as those used in xfsprogs.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
