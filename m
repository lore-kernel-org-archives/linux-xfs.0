Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0F7E7F66
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 17:50:43 -0500 (CDT)
Date: Mon, 9 Sep 2013 17:50:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2 v2] xfs: fix some minor sparse warnings
Message-ID: <20130909225043.GR1935@sgi.com>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
	<1378092179-24973-3-git-send-email-david@fromorbit.com>
	<20130902081954.GD11210@infradead.org>
	<20130902100957.GE12779@dastard> <20130902104936.GG12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902104936.GG12779@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Sep 02, 2013 at 08:49:36PM +1000, Dave Chinner wrote:
> xfs: fix some minor sparse warnings
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> A couple of simple locking annotations and 0 vs NULL warnings.
> Nothing that changes any code behaviour, just removes build noise.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
