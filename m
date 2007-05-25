Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 07:49:46 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4PEnfWt022607
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 07:49:43 -0700
Date: Fri, 25 May 2007 15:19:56 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RESVSP problems
Message-ID: <20070525141956.GA10669@infradead.org>
References: <200705241324.53283.lucke@o2.pl> <20070525050632.GG86004887@sgi.com> <200705251224.23624.lucke@o2.pl> <20070525112441.GQ85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525112441.GQ85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: ??ukasz Fibinger <lucke@o2.pl>, xfs@oss.sgi.com

On Fri, May 25, 2007 at 09:24:41PM +1000, David Chinner wrote:
> The original XFS specific code was here:
> 
> http://marc.info/?l=linux-fsdevel&m=117080251026985&w=2

Btw, I think you should just push it for now.  We can convert XFS to
the generic code once ->fault goes in whenever that may be.
