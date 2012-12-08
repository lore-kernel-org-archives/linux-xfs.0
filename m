Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8CbTsN032451 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 06:37:30 -0600
Date: Sat, 8 Dec 2012 07:39:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 5/5] xfs remove the XFS_TRANS_DEBUG routines
Message-ID: <20121208123955.GE29107@infradead.org>
References: <20121204231801.982422341@sgi.com>
	<20121204224938.990495241@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121204224938.990495241@sgi.com>
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

On Tue, Dec 04, 2012 at 05:18:06PM -0600, Mark Tinguely wrote:
> Remove the XFS_TRANS_DEBUG routines. They are no longer appropriate
> and have not been used in years
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
