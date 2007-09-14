Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 07:27:19 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EERD4p002702
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 07:27:15 -0700
Date: Fri, 14 Sep 2007 15:07:21 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Delete duplicate macro definitions.
Message-ID: <20070914140721.GA23878@infradead.org>
References: <Pine.LNX.4.64.0709140851130.20022@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709140851130.20022@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 08:53:20AM -0400, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   something that popped out of a script i have that scans for
> redundant macro definitions.  apply or not as you see fit.  not
> compile-tested as it was just done visually.

Yes, this is correct.  But I've already done this and a little more
in this area - these changes are in XFS CVS already and will go into
2.6.24.
