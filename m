Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P9Hk0m229924 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:17:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 033EC28DC85
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:20:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id V1t4lWRUMw77WUPt for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:20:09 -0800 (PST)
Date: Tue, 25 Jan 2011 04:20:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] xfs: 2.6.38-rc candidate fixes V2
Message-ID: <20110125092008.GA31405@infradead.org>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295945444-29488-1-git-send-email-david@fromorbit.com>
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

On Tue, Jan 25, 2011 at 07:50:36PM +1100, Dave Chinner wrote:
> These are all the pending 2.6.38-rc candidate fixes I have in my queue.

I'd limit the .38 series to actual regression fixes, which means
skipping patches 1, 2 and 7.  OTOH we really need to get the roundown
fix into Linus' tree ASAP as quite a few people hit it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
