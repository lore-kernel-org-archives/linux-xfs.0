Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 19:54:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E2sj4p017616
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 19:54:47 -0700
Message-ID: <46E9F7F3.6090405@sandeen.net>
Date: Thu, 13 Sep 2007 21:54:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: state of the cvs tree
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com> <20070913104000.GB3351@lst.de> <20070913234829.GW734179@sgi.com>
In-Reply-To: <20070913234829.GW734179@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:

>> Then I have a patch from Eric sitting in the front of my queue,
>>
>> 	"[PATCH V2] refactor xfs_mountfs for clarity & stack savings"
>>
>> which might be a little too big for 2.6.24, but should at least go into
>> CVS ASAP.  I think Eric would be really happy to see it in 2.6.24 aswell
>> because that means FC8 could actually mount xfs out of the box without
>> running out of stack or something.
> 
> Yeah, that's been floating about for a bit and has been tested in
> FC8 so seems like a no-brainer for .24.

you're assuming anyone besides me tested xfs in F8TestX... *grin*

(F8Test2 was released today... hint hint...)

-Eric
