Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAI0Sb062200 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:18:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E579A8ECB43
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:20:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PNJPF22dN5EsCdyo for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:20:05 -0700 (PDT)
Date: Thu, 29 Apr 2010 06:20:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsqa: build dbtest on debian platforms
Message-ID: <20100429102005.GC29677@infradead.org>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
	<1272500186-29393-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1272500186-29393-4-git-send-email-david@fromorbit.com>
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

On Thu, Apr 29, 2010 at 10:16:26AM +1000, Dave Chinner wrote:
> Set up autoconf to find the correct headers and compat libraries for
> debian squeeze, and massage the includes to ensure the right headers get
> included. Also fix a compile warning that was emitted now that it is being
> compiled.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Ah, nice.  I've been trying to get this working on Debian off and on
again for years, but never got this far.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
