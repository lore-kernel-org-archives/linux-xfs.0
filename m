Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 21:45:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2F4j3Tu026048
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:45:04 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C03BEFA55C5
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:45:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BFVLfC7FDonwCBt6 for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 21:45:35 -0700 (PDT)
Message-ID: <47DB5470.5020000@sandeen.net>
Date: Fri, 14 Mar 2008 23:45:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315043622.GA11547@puku.stupidest.org>
In-Reply-To: <20080315043622.GA11547@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:
> On Fri, Mar 14, 2008 at 11:23:43PM -0500, Eric Sandeen wrote:
> 
>> I think that packing structures when they don't need to be can
>> actually be harmful, efficiency-wise.  I read a nice explanation of
>> this....  which I can't find now.
> 
> objdump -d would show if that was the case...

it would show if that was the case for the particular compiler you test
I guess.

-Eric
