Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OIJt0S062280 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:19:55 -0600
Date: Tue, 24 Jan 2012 13:01:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path in
	xfs_readlink()
Message-ID: <20120124180102.GB23671@infradead.org>
References: <1326307930-21251-1-git-send-email-jack@suse.cz>
	<20120111191330.GQ20739@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120111191330.GQ20739@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>, stable@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Wed, Jan 11, 2012 at 01:13:30PM -0600, Ben Myers wrote:
> Looks good to me.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Can you send it on to Linus ASAP, please?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
