Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H9WLCp215451 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 03:32:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B7C5128DEA
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:31:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id blzO31bDjvGrtMVi for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 01:31:48 -0800 (PST)
Date: Tue, 17 Feb 2009 04:31:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: prevent kernel crash due to corrupted inode log format
Message-ID: <20090217093147.GA15620@infradead.org>
References: <20090215191344.GA16706@infradead.org>
	<200902162135.20065.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902162135.20065.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Christoph Hellwig <hch@infradead.org>, Andras Korn <korn-sgi.com@chardonnay.math.bme.hu>, xfs@oss.sgi.com

On Mon, Feb 16, 2009 at 09:35:19PM +0100, Arkadiusz Miskiewicz wrote:
> On Sunday 15 of February 2009, Christoph Hellwig wrote:
> > Andras Korn reported an oops on log replay causes by a corrupted
> 
> Where is that report? I'm wondering if it's the same issue as I'm seeing:
> 
> http://pld.pastebin.com/f15430869
> http://pld.pastebin.com/fbcdce88

Not related at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
