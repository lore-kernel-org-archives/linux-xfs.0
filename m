Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B1nYcx226441 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 20:49:34 -0500
Date: Wed, 10 Oct 2012 20:51:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/14 V5]: xfs: remove the xfssyncd mess
Message-ID: <20121011015103.GW13214@sgi.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<20121010213346.GA30760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121010213346.GA30760@infradead.org>
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

Hey Christoph,

On Wed, Oct 10, 2012 at 05:33:46PM -0400, Christoph Hellwig wrote:
> This version looks good to me, and I agree that the last_sync_lsn
> fix probably is a 3.7 candidate.
> 
> Feel free to add a:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> to the patches that don't have it yet.

Will do.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
