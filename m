Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT8C9bt130073 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 02:12:09 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 102151B0491
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 00:13:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tfS0A2T5YqtLJP4v for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 00:13:50 -0800 (PST)
Date: Mon, 29 Nov 2010 03:13:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: only run xfs_error_test if error injection is
	active
Message-ID: <20101129081350.GC25894@infradead.org>
References: <1290990024-15898-1-git-send-email-david@fromorbit.com>
	<1290990024-15898-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290990024-15898-6-git-send-email-david@fromorbit.com>
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

Looks good, but I'm not sure if we should bother for 2.6.37 anymore at
this point - it's getting pretty late in the cycle.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
