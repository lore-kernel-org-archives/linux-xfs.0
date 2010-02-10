Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ALuUDi083837 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 15:56:31 -0600
Date: Wed, 10 Feb 2010 16:57:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2/2] xfs_export_operations.commit_metadata
Message-ID: <20100210215744.GB25004@infradead.org>
References: <20100210003220.6021.74943.stgit@case>
	<20100210003337.6021.10942.stgit@case>
	<20100210090750.GB21875@infradead.org>
	<20100210201527.GJ23654@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100210201527.GJ23654@sgi.com>
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
To: bpm@sgi.com
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 10, 2010 at 02:15:27PM -0600, bpm@sgi.com wrote:
> > Note that _xfs_log_force_lsn is new in the XFS tree, mainline still
> > has _xfs_log_force with an lsn argument.
> 
> I've been working with Bruce's tree.  Not sure how best to handle that.

Keep working against it for now, the merge fixup will be easy enough.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
