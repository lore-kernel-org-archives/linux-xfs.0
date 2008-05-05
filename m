Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 11:30:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m45IUdMd014920
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 11:30:42 -0700
Date: Mon, 5 May 2008 14:31:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: xfstests/016 change
Message-ID: <20080505183122.GA11163@infradead.org>
References: <481E7F17.5090601@sgi.com> <20080505055446.GB15609@infradead.org> <481EA70A.2030500@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481EA70A.2030500@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, May 05, 2008 at 04:19:54PM +1000, Timothy Shimmin wrote:
> Groan. Sorry.
> I'll attach 016.patch for the moment.
>
> Need to see where things went wrong with the whitespace.

Still fails for me with that patch applied:

016 43s ...
 - output mismatch (see 016.out.bad)
13a14,17
> *** generate log traffic
>    *** mount
>    *** fiddle
>    *** unmount
Failures: 016
Failed 1 of 1 tests
