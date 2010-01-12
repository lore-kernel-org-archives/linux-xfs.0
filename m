Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C9UeUF252220 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 03:30:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46C8915AB0B
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 01:31:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DD1qDGlOtMaxJ1EF for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 01:31:35 -0800 (PST)
Date: Tue, 12 Jan 2010 04:31:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfsqa: filter the fsstress seed output in 104
Message-ID: <20100112093133.GA20017@infradead.org>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
	<1263271269-18997-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263271269-18997-2-git-send-email-david@fromorbit.com>
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

On Tue, Jan 12, 2010 at 03:41:06PM +1100, Dave Chinner wrote:
> Otherwise it fails to match the golden output. Also add
> the test to the auto group so that it is run regularly now
> that the growfs problems are fixed.

Well, they're not actually fixed yet, Alex still needs to push out your
patches to the xfs tree :)

anyway, patch looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
