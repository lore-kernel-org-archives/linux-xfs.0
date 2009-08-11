Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7B2rde2097032 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 21:53:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C682147C543
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 19:53:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 29ebieQGobL4QPU3 for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 19:53:58 -0700 (PDT)
Date: Mon, 10 Aug 2009 22:53:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Best design docs for XFS
Message-ID: <20090811025356.GA28108@infradead.org>
References: <4A808FC7.2020800@jquigley.com> <4A80A597.6050806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A80A597.6050806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>

On Mon, Aug 10, 2009 at 05:56:23PM -0500, Eric Sandeen wrote:
> It's pretty good still, the fundamental design is not substantially
> changed; you're more likely to find missing bits than "wrong" bits I think.
> 
> http://oss.sgi.com/projects/xfs/training/index.html
> 
> has more info as well.

The fundamental design is mostly unchanged.  What you might now want to
bother reading of the original documents are:

 dir_design.pdf - the dir code has been completely replaced
 threads.pdf - this is totally IRIX specific
 scaffold.pdf - again mostly IRIX specific
 message.pdf - no idea what this is at all, I never saw traces of this
 in XFS

For all others there's quite a bit of IRIXism in there.

Is there anything specific you're looking for?


> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
