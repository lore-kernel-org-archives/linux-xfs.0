Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OEoYVT130252 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 09:50:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F426151E1ED
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 07:51:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ks28gY1KF8byQu9B for
	<xfs@oss.sgi.com>; Mon, 24 Aug 2009 07:51:03 -0700 (PDT)
Date: Mon, 24 Aug 2009 10:47:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_check does not recognize fs truncation
Message-ID: <20090824144752.GA20898@infradead.org>
References: <alpine.LSU.2.00.0908241208520.1028@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0908241208520.1028@fbirervta.pbzchgretzou.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 24, 2009 at 12:12:59PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> This I see on xfsprogs-2.10.1 with kernel 2.6.29.6:

What does xfs_repair -n say?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
