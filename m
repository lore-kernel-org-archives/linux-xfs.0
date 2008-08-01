Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:34:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JXnU9023922
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:33:59 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 102A379F655
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:35:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id MSZf9a3CUzBCftQU for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:35:02 -0700 (PDT)
Message-ID: <48936564.706@sandeen.net>
Date: Fri, 01 Aug 2008 14:35:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Cleanup more dir v1 macros and stuff
References: <op.ue043mr13jf8g2@pc-bnaujok.melbourne.sgi.com> <20080801192245.GA26807@infradead.org>
In-Reply-To: <20080801192245.GA26807@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Jul 29, 2008 at 11:29:36AM +1000, Barry Naujok wrote:
>> Well, it seems I found a few remnants (cookie crumbs) of dirv1 stuff
>> in the kernel! This patch removes those remnants!
> 
> 
> Looks good.
> 
> 

is the 0x7fffffff stuff in xfs_file.c also a dir v1 remnant?  cvs
history seems to indicate so....

-Eric
