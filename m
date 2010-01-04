Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04F9GUx123947 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 09:09:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 366FE4CA001
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 07:10:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fmPgRotz18W3MjX5 for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 07:10:06 -0800 (PST)
Date: Mon, 4 Jan 2010 10:10:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Use list_heads for log recovery item lists
Message-ID: <20100104151005.GA24810@infradead.org>
References: <1262400014-19360-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262400014-19360-1-git-send-email-david@fromorbit.com>
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

On Sat, Jan 02, 2010 at 01:40:14PM +1100, Dave Chinner wrote:
> Remove the roll-your-own linked list operations.

Looks good.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
