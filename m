Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Oct 2008 16:59:36 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m95Nx5u7030468
	for <xfs@oss.sgi.com>; Sun, 5 Oct 2008 16:59:06 -0700
Message-ID: <48E9631A.8050404@sgi.com>
Date: Mon, 06 Oct 2008 11:00:10 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 987159 - Fix extent list corruption in xfs_iext_irec_compact_full().
References: <20080923032821.A91D758C52AE@chook.melbourne.sgi.com> <48E8AB5A.7080301@sandeen.net> <48E8AC57.4050503@sandeen.net>
In-Reply-To: <48E8AC57.4050503@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Lachlan McIlroy wrote:
> 
> 
>>> 	- Fix extent list corruption in xfs_iext_irec_compact_full().
>> Are there plans to try to get this, and possibly the compact_full
>> removal pushed into 2.6.27 still?  (and maybe even 2.6.26.x?)
>>
>> -Eric
>>
>>
> 
> ugh already in, sorry.  ignore me!

yes, already in .27, but not yet .26 as far as I know.

Cheers

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
