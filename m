Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99N7T5011508 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:23:07 -0600
Date: Tue, 9 Dec 2008 04:23:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove unused tracing code
Message-ID: <20081209092305.GB23915@infradead.org>
References: <493DEDB5.8010401@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <493DEDB5.8010401@sgi.com>
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

On Tue, Dec 09, 2008 at 03:01:57PM +1100, Lachlan McIlroy wrote:
> None of this code appears to be used anywhere so remove it.
> The only changes going to mainline are the one-liners in xfs_inode.[ch].

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
