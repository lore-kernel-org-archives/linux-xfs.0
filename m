Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FIXchN115003 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 13:33:38 -0500
Date: Mon, 15 Aug 2011 14:33:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: refactor exit_codestring()
Message-ID: <20110815183337.GB1758@infradead.org>
References: <1313430212-20028-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1313430212-20028-1-git-send-email-wkendall@sgi.com>
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

On Mon, Aug 15, 2011 at 12:43:32PM -0500, Bill Kendall wrote:
> Simplify exit_codestring(), which maps an exit code into a string.
> Make it available to all code which includes "exit.h".
> 
> Also remove the unused type "exit_t".

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
