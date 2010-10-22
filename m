Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9MCmFQW178154 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 07:48:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FEE415FA301
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 06:04:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xhCQS8khfySOO5fx for
	<xfs@oss.sgi.com>; Fri, 22 Oct 2010 06:04:41 -0700 (PDT)
Date: Fri, 22 Oct 2010 08:49:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Implementing checksums in XFS
Message-ID: <20101022124928.GA16437@infradead.org>
References: <4CC14C1B.5060409@ics.forth.gr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CC14C1B.5060409@ics.forth.gr>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

On Fri, Oct 22, 2010 at 11:32:27AM +0300, Yannis Klonatos wrote:
> Hi all,
> 
>         I would like to ask whether, since implementing checksums
> seams to be the current  trend for file-systems
> (e.g. EXT4, BTRFS), anyone is planning on providing such
> functionality for XFS also.

Yes, it's work in progress that has been stalled a little.  See:
http://oss.sgi.com/archives/xfs/2009-02/msg00200.html for some more
details.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
