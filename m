Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4798pv031880 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:09:08 -0600
Date: Thu, 4 Dec 2008 02:09:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove unused variable in ktrace_free()
Message-ID: <20081204070907.GD29531@infradead.org>
References: <4937765D.2030601@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4937765D.2030601@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 05:19:09PM +1100, Lachlan McIlroy wrote:
> entries_size is probably left over from when we used to pass the
> size to kmem_free().

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
