Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 04:37:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3UBbAdF008769
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 04:37:13 -0700
Date: Wed, 30 Apr 2008 07:37:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove l_flushsema
Message-ID: <20080430113753.GA17871@infradead.org>
References: <20080430090502.GH14976@parisc-linux.org> <20080430104125.GM108924158@sgi.com> <20080430105832.GA20442@infradead.org> <20080430111154.GO108924158@sgi.com> <20080430111521.GA16571@infradead.org> <20080430113418.GP108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430113418.GP108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, xfs@oss.sgi.com

On Wed, Apr 30, 2008 at 09:34:18PM +1000, David Chinner wrote:
> > probably loose some arguments).
> 
> Yep, much cleaner. Who's signoff goes on this?

You can have mine:

Signed-off-by: Christoph Hellwig <hch@lst.de>

but I think it's till essentially willy's and he should be credited for
it.
