Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 18:29:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m461TMe2017903
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 18:29:26 -0700
Message-ID: <481FB495.6040709@sgi.com>
Date: Tue, 06 May 2008 11:29:57 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: xfstests/016 change
References: <481E7F17.5090601@sgi.com> <20080505055446.GB15609@infradead.org> <481EA70A.2030500@sgi.com> <20080505183122.GA11163@infradead.org>
In-Reply-To: <20080505183122.GA11163@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 04:19:54PM +1000, Timothy Shimmin wrote:
>> Groan. Sorry.
>> I'll attach 016.patch for the moment.
>>
>> Need to see where things went wrong with the whitespace.
> 
> Still fails for me with that patch applied:
> 
> 016 43s ...
>  - output mismatch (see 016.out.bad)
> 13a14,17
>> *** generate log traffic
>>    *** mount
>>    *** fiddle
>>    *** unmount
> Failures: 016
> Failed 1 of 1 tests

Forgot adding 016.out change to patch.
The failure diff above means it worked ;-)

--Tim
