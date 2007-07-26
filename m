Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 11:13:56 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QIDpbm029344
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 11:13:52 -0700
Date: Thu, 26 Jul 2007 18:56:40 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsqa 144 is failing now
Message-ID: <20070726175640.GA2940@infradead.org>
References: <20070712150431.GA3763@infradead.org> <20070712222304.GA31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712222304.GA31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jul 13, 2007 at 08:23:05AM +1000, David Chinner wrote:
> Not yet - AFAIK we're only seeing it on i386 ATM, and we only noticed it in
> the past couple of days. Nobody has had a chance to look at it yet. I don't
> think dmapi has been tested regularly on i386 so I'm not sure when the problem
> first appeared yet.

Btw, the xfstests/dmapi/src/suite1/cmd/get_dirattrs works perfectly even
on i386.  So there must be something that's broken in the actual testcase.
