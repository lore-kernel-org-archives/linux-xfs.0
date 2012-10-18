Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IMol9K218691 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 17:50:47 -0500
Date: Thu, 18 Oct 2012 17:52:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 3/3 v2] xfs: zero allocation_args on the kernel stack
Message-ID: <20121018225226.GK1377@sgi.com>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.587098223@sgi.com>
	<20120920181650.041917183@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120920181650.041917183@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Mark,

On Thu, Sep 20, 2012 at 01:16:45PM -0500, Mark Tinguely wrote:
> Zero the kernel stack space that makes up the xfs_alloc_arg structures.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

This has been committed to git://oss.sgi.com/xfs/xfs.git, master and for-next
branches.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
