Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 17:34:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K1YE9H032233
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 17:34:17 -0800
Message-ID: <47BB8367.8000700@sgi.com>
Date: Wed, 20 Feb 2008 12:33:27 +1100
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, mainline-only] remove sendfile leftovers
References: <20080208044256.GA15013@lst.de> <20080219225746.GA26576@infradead.org>
In-Reply-To: <20080219225746.GA26576@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com



Christoph Hellwig wrote:
> On Fri, Feb 08, 2008 at 05:42:57AM +0100, Christoph Hellwig wrote:
>> Remove the last sendfile leftovers in mainline.  This code is already
>> gone in CVS.
> 
> Any chance to pass on these three no-risk mainline-only patches to
> Linus?  I'm pretty sure they'll get lost otherwise until the next
> merge window..

Lachlan, has this been pushed upstream yet?

Thanks

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
