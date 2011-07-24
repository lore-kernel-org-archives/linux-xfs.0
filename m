Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBUUwY205759 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:30:30 -0500
Date: Sun, 24 Jul 2011 07:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: encapsulate a block of debug code
Message-ID: <20110724113028.GA23267@infradead.org>
References: <201107181814.p6IIEAZm028909@stout.americas.sgi.com>
	<20110719171028.GA31088@infradead.org>
	<1311104952.1964.24.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311104952.1964.24.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 19, 2011 at 02:49:12PM -0500, Alex Elder wrote:
> What about xfs_da_blkinfo_onlychild_validate()?

Sounds a bit clumsy, but given that I can't suggest a better one I'm
fine with it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
