Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 May 2007 17:50:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4S0oKWt027517
	for <xfs@oss.sgi.com>; Sun, 27 May 2007 17:50:23 -0700
Date: Mon, 28 May 2007 10:50:10 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RESVSP problems
Message-ID: <20070528005010.GV85884050@sgi.com>
References: <200705241324.53283.lucke@o2.pl> <20070525050632.GG86004887@sgi.com> <200705251224.23624.lucke@o2.pl> <20070525112441.GQ85884050@sgi.com> <20070525141956.GA10669@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525141956.GA10669@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, ??ukasz Fibinger <lucke@o2.pl>, xfs@oss.sgi.com

On Fri, May 25, 2007 at 03:19:56PM +0100, Christoph Hellwig wrote:
> On Fri, May 25, 2007 at 09:24:41PM +1000, David Chinner wrote:
> > The original XFS specific code was here:
> > 
> > http://marc.info/?l=linux-fsdevel&m=117080251026985&w=2
> 
> Btw, I think you should just push it for now.  We can convert XFS to
> the generic code once ->fault goes in whenever that may be.

Ok - That original code had a coupl eof problems, so I'll fix
it up first...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
