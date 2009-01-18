Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0IM8UsE031390 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 16:08:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 961979ADA3
	for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 14:08:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jbkW58ADepxd7aXI for
	<xfs@oss.sgi.com>; Sun, 18 Jan 2009 14:08:24 -0800 (PST)
Date: Sun, 18 Jan 2009 17:06:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-ID: <20090118220657.GA14814@infradead.org>
References: <20090113105947.9e774b69.akpm@linux-foundation.org>
	<20090113191757.74290@gmx.net>
	<20090113113700.776a94b5.akpm@linux-foundation.org>
	<20090113203843.GJ29283@parisc-linux.org>
	<1231957750.8269.28.camel@think.oraclecorp.com>
	<496E56EB.2030301@gmx.de>
	<1231968240.8269.48.camel@think.oraclecorp.com>
	<496E5AB2.7040507@sandeen.net>
	<20090114134417.e6b29b52.akpm@linux-foundation.org>
	<496E5DB8.1030007@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <496E5DB8.1030007@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: handygewinnspiel@gmx.de, matthew@wil.cx, linux-kernel@vger.kernel.org, mchehab@infradead.org, rjw@sisk.pl, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, HWerner4@gmx.de, Andrew Morton <akpm@linux-foundation.org>, xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@lst.de>, stable@kernel.org, chris.mason@oracle.com

On Wed, Jan 14, 2009 at 03:48:40PM -0600, Eric Sandeen wrote:
> > This patch applies OK to 2.6.27 and 2.6.28.  Is it also needed there? 
> > If so, it should have had "Cc: <stable@kernel.org>" in the changelog so
> > that it doesn't get lost.
> > 
> 
> It is needed for .28, but should not be needed for .27 AFAIK.

That's correct.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
