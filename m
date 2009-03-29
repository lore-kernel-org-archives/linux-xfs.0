Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7ctqL117698 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:39:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DCF51D1517
	for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:38:11 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3dBRHuwfjlfEIlIV for
	<xfs@oss.sgi.com>; Sun, 29 Mar 2009 00:38:11 -0700 (PDT)
Date: Sun, 29 Mar 2009 03:38:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests license clarification?
Message-ID: <20090329073809.GA10444@infradead.org>
References: <49CE3A1A.9020103@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49CE3A1A.9020103@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, Mar 28, 2009 at 09:54:18AM -0500, Eric Sandeen wrote:
> Since most of the scripts themselves in xfstests make no mention of
> redistribution, and only say "copyright sgi, all rights reserved" etc:
> 
> #-----------------------------------------------------------------------
> #  Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
> #-----------------------------------------------------------------------
> 
> do we need to do anything in terms of making this look more like Free
> Software (assuming that's the intent?)
> 
> It might be a rats-nest, there are a several testcases in src/ gleaned
> from mailing lists & bugs with little or no attribution; OTOH maybe this
> stuff is trivial enough that it doesn't warrant copyright, I dunno.
> 
> Is it worth trying to clarify the license on the collection, or is this
> just a can of worms?

While only a couple of files have the same, just with me as a copyright
holder I'm willing to license it under whatever free license suits best.

I suspect BSD might be best for test code like this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
