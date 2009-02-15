Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1FJGUi3090933 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 13:16:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 690271940456
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:15:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cnUhBFgS4YinLYMN for
	<xfs@oss.sgi.com>; Sun, 15 Feb 2009 11:15:56 -0800 (PST)
Date: Sun, 15 Feb 2009 14:15:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090215191525.GA25526@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<200902042027.40762.nickpiggin@yahoo.com.au>
	<20090204193846.GA26436@infradead.org>
	<200902101543.15988.nickpiggin@yahoo.com.au>
	<20090210075455.GA27111@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210075455.GA27111@infradead.org>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: xfs@oss.sgi.com

Given how late we are in the 2.6.29 process we should probably revert
95f8e302c04c0b0c6de35ab399a5551605eeb006 and
d2859751cd0bf586941ffa7308635a293f943c17 and try again for 2.6.30.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
