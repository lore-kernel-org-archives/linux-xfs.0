Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJwWH1071947 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:58:33 -0600
Date: Tue, 10 Feb 2009 14:57:56 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix error handling in xfs_log_mount
Message-ID: <20090210195756.GA7569@infradead.org>
References: <20090210194422.767988000@bombadil.infradead.org>
	<20090210194515.509547000@bombadil.infradead.org>
	<A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <A482AB92-6E29-43EA-A671-43D86E041335@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Feb 10, 2009 at 01:56:31PM -0600, Felix Blyakher wrote:
> Isn't it a reworked Lachlan's patch:
>
> http://oss.sgi.com/archives/xfs/2009-02/msg00175.html

The patch isn't related to that one at all, but it aims to fix the
same issue.  Should probably get a Reported-by: tag for him, if
this is indeed the thing the original patch tried to fix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
