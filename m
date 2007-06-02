Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 15:27:09 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l52MR5Wt016783
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2007 15:27:06 -0700
Date: Sat, 2 Jun 2007 18:27:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <alpine.DEB.0.99.0706022253130.16496@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.64.0706021826470.4161@p34.internal.lan>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <alpine.DEB.0.99.0706022253130.16496@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Jun  2 18:23:23 p34 upsd[2225]: Can't connect to UPS [belkin] 
(newhidups-auto): No such file or directory
Jun  2 18:24:23 p34 upsmon[2228]: Poll UPS [belkin@localhost] failed - 
Driver not connected

Hmm, something changes with USB in 2.6.22-rc3 form 2.6.21..

On Sat, 2 Jun 2007, Christian Kujau wrote:

> On Sat, 2 Jun 2007, Justin Piszcz wrote:
>> Wondering as their were a lot of XFS related issues early on in 
>> development..?  The 2.6.22-rc3 kernel has the core 2 duo coretemp patch by 
>> ruik which I want be running as long as 2.6.22-rc3 does not have any severe 
>> XFS issues?
>
> Tracking -rc and running 2.6.22-rc3 for a couple of days now, no problems 
> with xfs since this infamous 2.6.17 thingy[0]. But that's pretty useless 
> information I guess, since your setup will be different from mine. Did you 
> have anything "special" in mind when asking this?
>
> C.
>
> [0] http://oss.sgi.com/projects/xfs/faq.html#dir2
> -- 
> BOFH excuse #339:
>
> manager in the cable duct
>
>
