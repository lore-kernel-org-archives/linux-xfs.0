Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 18:00:42 -0700 (PDT)
Received: from buick.jordet.net (buick.jordet.net [217.8.143.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7P10PDW012332
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 18:00:26 -0700
Subject: Re: xfs bug in 2.6.17.9?
From: Stian Jordet <liste@jordet.net>
In-Reply-To: <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com>
	 <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan>
Content-Type: text/plain
Date: Fri, 25 Aug 2006 01:47:43 +0200
Message-Id: <1156463263.19666.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

tor, 24,.08.2006 kl. 09.42 -0400, skrev Justin Piszcz:
> Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216
> 
> That is the bug from 2.6.17 -> 2.6.17.6.
> 
> It was patched in 2.6.17.7, but I assume(?) if you never fixed your FS to 
> begin with, you will still have the problem.  Read the XFS FAQ, and backup 
> your data before you do that :)

As I just wrote to Martin, I did run a couple of those kernels. But even
with updated xfsprogs I can't fix the errors... Is that "normal", or am
I in deep trouble?

Best regards,
Stian
