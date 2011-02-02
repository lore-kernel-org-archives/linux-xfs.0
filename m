Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p121trB4258261 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 19:55:54 -0600
Subject: Re: [PATCH 0/3] resurrect realtime subvolume support
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110125090618.432370964@bombadil.infradead.org>
References: <20110125090618.432370964@bombadil.infradead.org>
Date: Tue, 01 Feb 2011 19:58:19 -0600
Message-ID: <1296611899.2350.165.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Tue, 2011-01-25 at 04:06 -0500, Christoph Hellwig wrote:
> Fix two regressions that broke using the realtime subvolume, and
> add lockdep annotations for the ilocks of the two rt metadata inodes.

I reviewed all three patches in this series, i.e.:

Reviewed-by: Alex Elder <aelder@sgi.com>

I'll give it another day or so to give others a
chance to review, but otherwise I will incorporate
all three from your posted patches.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
