Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 04:27:31 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9VBRO9A031992
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 04:27:25 -0700
Date: Wed, 31 Oct 2007 07:27:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Default mount options (that suck less).
In-Reply-To: <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org>
Message-ID: <Pine.LNX.4.64.0710310727090.8545@p34.internal.lan>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net>
 <47267EC7.8000906@sgi.com> <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Braid <jamesb@loreland.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com



On Wed, 31 Oct 2007, James Braid wrote:

> On 30 Oct 2007, at 00:45, Timothy Shimmin wrote:
>> It might be interesting if people let us know what non-default
>> mkfs and mount options that they are using for their various
>> configurations/classes.
>> Didn't Russell C. have some survey years ago - can't remember if
>> that was for h/ware or what now.
>
> We have a ~100TB filesystem that was made with the default mkfs.xfs options 
> from memory. The only mount option we use is inode64.
>

Impressive, what architecture do you run? ia64 or x86_64?  What 
performance differences did you see?

Justin.
