Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 04:13:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9SBCVYb014371
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 04:12:33 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30FCB551346
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 03:53:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id mn63TtvwBUT1w9G8 for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 03:53:22 -0700 (PDT)
Date: Tue, 28 Oct 2008 06:53:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Urgent queue
Message-ID: <20081028105321.GA30522@infradead.org>
References: <20081027133010.GA30607@infradead.org> <20081028064150.GS4985@disturbed> <4906EB5B.2020004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906EB5B.2020004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 09:37:15PM +1100, Mark Goodwin wrote:
> individually (by series) or only after all 30? Bisectability is important,
> as Christoph alluded to in another thread. Is the intention to try and take
> this lot for 28-rc3? I think Lachlan is now very close to a pull req for
> .28, depending on his testing for the memleak and deadlock fixes - time
> is now getting pretty short :)

Even urgent isn't urgent enough for the first 2.6.28 series, please get
that one out ASAP, I don't want to miss it.  The two patches from the
urgent queue are something I would consider for a second .28 pull,
everything else is .29 material.

But it would be highly useful if we could open up a .29 staging tree that
can be QAed and included in linux-next ASAP..
