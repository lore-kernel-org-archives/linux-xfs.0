Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 09:52:20 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6CGqEbm032555
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 09:52:16 -0700
Date: Thu, 12 Jul 2007 17:52:16 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsqa 144 is failing now
Message-ID: <20070712165216.GA8357@infradead.org>
References: <20070712150431.GA3763@infradead.org> <Pine.LNX.4.64.0707121243470.28925@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707121243470.28925@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jul 12, 2007 at 12:43:56PM -0400, Justin Piszcz wrote:
> Curious, what do you use that utilizes DMAPI?

xfsqa :)  There's a lot of dmapi tests in there, including the one
that fails.
