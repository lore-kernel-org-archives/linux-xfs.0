Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALHHmAA011637 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 11:17:48 -0600
Date: Mon, 21 Nov 2011 11:18:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: validate acl count
Message-ID: <20111121171805.GO29840@sgi.com>
References: <20111120153532.GA26918@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111120153532.GA26918@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Nov 20, 2011 at 10:35:32AM -0500, Christoph Hellwig wrote:
> This prevents in-memory corruption and possible panics if the on-disk
> ACL is badly corrupted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
