Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QBPRS3004476 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 06:25:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ACDCFBAA1C
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 04:25:23 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bkrqGTuHlRBzCOPv for <xfs@oss.sgi.com>;
	Wed, 26 Oct 2011 04:25:23 -0700 (PDT)
Date: Wed, 26 Oct 2011 07:25:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111026112521.GA10432@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
	<20111024082219.GA19941@infradead.org>
	<20111025200748.GA25043@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111025200748.GA25043@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 25, 2011 at 01:07:48PM -0700, Simon Kirby wrote:
> This patch seems to work, at least on an SSD box. No more hung task
> warnings, and everything appears normal.
> 
> Do we know what caused this regression and/or how to fix it without the
> big hammer, or do we need to break it down further?

I have an idea and will send you a refined patch soon.  I'm at a
conference until tomorrow, so you'll probably have to wait another day
or two for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
