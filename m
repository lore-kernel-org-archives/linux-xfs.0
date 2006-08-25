Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 22:36:11 -0700 (PDT)
Received: from smtp106.sbc.mail.mud.yahoo.com (smtp106.sbc.mail.mud.yahoo.com [68.142.198.205])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7P5ZxDW011187
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 22:35:59 -0700
Date: Thu, 24 Aug 2006 22:08:38 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs bug in 2.6.17.9?
Message-ID: <20060825050838.GA1322@tuatara.stupidest.org>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com> <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan> <1156463263.19666.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1156463263.19666.7.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stian Jordet <liste@jordet.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Fri, Aug 25, 2006 at 01:47:43AM +0200, Stian Jordet wrote:

> As I just wrote to Martin, I did run a couple of those kernels. But
> even with updated xfsprogs I can't fix the errors... Is that
> "normal", or am I in deep trouble?

More recent xfs_repair will deal better with it, I think it's in CVS
now, I'm not entirely sure though.  Search for the XFS faq, at the end
there is a section on directory corruption and details on how to fix
it by hand if need be.
