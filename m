Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 01:45:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4U8jcWt031422
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 01:45:39 -0700
Date: Wed, 30 May 2007 04:45:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
In-Reply-To: <20070530022524.GA20275@tuatara.stupidest.org>
Message-ID: <Pine.LNX.4.64.0705300445230.3755@p34.internal.lan>
References: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
 <20070530004140.GX85884050@sgi.com> <20070530022524.GA20275@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, apiszcz@solarrain.com



On Tue, 29 May 2007, Chris Wedgwood wrote:

> On Wed, May 30, 2007 at 10:41:40AM +1000, David Chinner wrote:
>
>> Remember - xfs_fsr does best effort defrag - if it can't make
>> progress, it does nothing, and it can't defrag directories...
>
> Also, it's not going to do much in many cases unless you have free
> space...  if you don't have enough *suitable* free space then it won't
> be able to do much.
>

Currently have 101GB used with 645GB free.

Justin.
