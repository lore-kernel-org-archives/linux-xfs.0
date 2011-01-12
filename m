Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0CC7xG4185946 for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 06:08:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFCB51D28072
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 04:10:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gpts4DUiynqvXaql for
	<xfs@oss.sgi.com>; Wed, 12 Jan 2011 04:10:12 -0800 (PST)
Date: Wed, 12 Jan 2011 07:10:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20110112121010.GA32321@infradead.org>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<1294792553-8378-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294792553-8378-2-git-send-email-david@fromorbit.com>
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

Looks good.  I think this patch also still is a candidate for 2.6.38,
while the rest looks more like 2.6.39 material.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
