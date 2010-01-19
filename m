Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9OYrM180487 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:24:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD6891C5DF21
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:25:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rDzv65e5oPrfQz9w for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:25:34 -0800 (PST)
Date: Tue, 19 Jan 2010 04:25:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: convert dirnameops to unsigned char names
Message-ID: <20100119092534.GC7168@infradead.org>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
	<1263861026-13448-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861026-13448-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 11:30:21AM +1100, Dave Chinner wrote:
> To be consistent across the codebase, convert the dirnameops to pass
> the directory names by unsigned char strings.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
