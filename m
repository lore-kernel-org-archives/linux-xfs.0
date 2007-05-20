Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 16:44:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4KNiafB029998
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 16:44:38 -0700
Date: Mon, 21 May 2007 09:44:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070520234432.GB85884050@sgi.com>
References: <20070520233417.GA85884050@sgi.com> <20070520234048.GA7423@tuatara.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520234048.GA7423@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, May 20, 2007 at 04:40:48PM -0700, Chris Wedgwood wrote:
> 
> Once people are happy with this it should be checked to see if it
> needs to go into -stable.

It's new code so -stable is irrelevant....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
