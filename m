Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BLn645181873 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 15:49:06 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C6E515A4E2
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:50:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id o0B3QCHJ9rNlC5gb for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:50:00 -0800 (PST)
Date: Mon, 11 Jan 2010 16:50:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] XFS: Use list_heads for log recovery item lists
Message-ID: <20100111215000.GB10278@infradead.org>
References: <1263210599-25067-1-git-send-email-david@fromorbit.com>
	<1263210599-25067-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263210599-25067-2-git-send-email-david@fromorbit.com>
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

On Mon, Jan 11, 2010 at 10:49:57PM +1100, Dave Chinner wrote:
> Remove the roll-your-own linked list operations.

I can't spot any changes since the version I reviewed a few days ago,
so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
