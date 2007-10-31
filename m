Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 19:48:29 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9V2mPXt029226
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 19:48:26 -0700
Subject: Re: 2.6TB Storage Size Problem
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <13501909.post@talk.nabble.com>
References: <13501909.post@talk.nabble.com>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 13:48:23 +1100
Message-Id: <1193798904.3862.106.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "paul.lkw" <paul.lkw@mfun.org>
Cc: xfs@oss.sgi.com

On Tue, 2007-10-30 at 19:35 -0700, paul.lkw wrote:
> 
> size should be 2.5xxxTB, but however I just have 2.0T as EXT-3
> limitation (I

DOS partition size limitation more likely - use a different
partitioning scheme, or just don't partition the device.

cheers.

-- 
Nathan
