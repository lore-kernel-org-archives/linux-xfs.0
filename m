Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 02:50:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3E9njeR026758
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 02:49:46 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C67C9CB94F
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 02:50:23 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id VrBN7PetrFlUamMZ for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 02:50:23 -0700 (PDT)
Date: Mon, 14 Apr 2008 05:50:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_check: out of memory
In-Reply-To: <1208163492.2436.11.camel@warndt.eurodata.de>
Message-ID: <alpine.DEB.1.10.0804140550160.4355@p34.internal.lan>
References: <1208163492.2436.11.camel@warndt.eurodata.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Koch <a.koch@eurodata.de>
Cc: xfs@oss.sgi.com



On Mon, 14 Apr 2008, Andreas Koch wrote:

> Hello all.
>
> I have a 2TB Partition.
>
> When i want to check the Partition, xfs_check return -> out of memory.
>
> The Memory (2GB) was realy full.
>
> How i can check this great Partition.
>
> Best Regards
>
> Andreas Koch
>
>

What about xfs_repair or xfs_repair -n ?
