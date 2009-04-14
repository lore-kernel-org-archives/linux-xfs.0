Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3EGNITv203656 for <xfs@oss.sgi.com>; Tue, 14 Apr 2009 11:23:34 -0500
Date: Tue, 14 Apr 2009 12:23:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] Handle possible bio_alloc failure in xfs
Message-ID: <20090414162301.GA24967@infradead.org>
References: <200904141636.45463.knikanth@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200904141636.45463.knikanth@suse.de>
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
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Tue, Apr 14, 2009 at 04:36:45PM +0530, Nikanth Karthikesan wrote:
> Handle bio_alloc failure in xfs.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

NAK, as already explained by Jens.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
