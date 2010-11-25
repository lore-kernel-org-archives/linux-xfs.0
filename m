Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAP7Zawp238137 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 01:35:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9B2A13EB28E
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:37:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lQhrfrjoeoOoghDe for
	<xfs@oss.sgi.com>; Wed, 24 Nov 2010 23:37:15 -0800 (PST)
Date: Thu, 25 Nov 2010 02:37:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: push stale, pinned buffers on trylock failures
Message-ID: <20101125073712.GA27959@infradead.org>
References: <1290597873-5807-1-git-send-email-david@fromorbit.com>
	<1290597873-5807-3-git-send-email-david@fromorbit.com>
	<20101124172051.GA32129@infradead.org>
	<20101125002834.GB12187@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101125002834.GB12187@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
