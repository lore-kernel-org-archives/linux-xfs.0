Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAot4K086044 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:51:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CFCD1C460DD
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:50:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rEH7L4zEE47yoMFr for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:50:34 -0700 (PDT)
Date: Mon, 16 Mar 2009 06:50:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] [XFS] Validate log feature fields correctly
Message-ID: <20090316105034.GA13508@infradead.org>
References: <1237116342-25701-1-git-send-email-david@fromorbit.com>
	<1237116342-25701-2-git-send-email-david@fromorbit.com>
	<20090315151546.GB7145@infradead.org>
	<20090316104904.GK26138@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316104904.GK26138@disturbed>
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 09:49:04PM +1100, Dave Chinner wrote:
> I just find large numbers easier to parse in hex, especially as
> we are expecting power-of-2 type numbers to come out of this.
> I'll change it....

True, the power of two would be an argument for hex.  Feel free to keep
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
