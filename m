Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 06:54:47 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lACEsJrR013771
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 06:54:22 -0800
Date: Mon, 12 Nov 2007 09:54:25 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs options
In-Reply-To: <473844ED.7080605@jamendo.com>
Message-ID: <Pine.LNX.4.64.0711120953590.2701@p34.internal.lan>
References: <473844ED.7080605@jamendo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Amandine AUPETIT <amandine@jamendo.com>
Cc: xfs@oss.sgi.com



On Mon, 12 Nov 2007, Amandine AUPETIT wrote:

> Hi :)
>
> I have a 7tb XFS filesystem. The partition is supposed to stock big files 
> between 2mo and 50mo. Quite no small files.
>
> So i'm trying to adapt the mount option to what I need, and what I need is 
> security. I want to be sure that NONE of the files will be lost, even if 
> there's a power failure.
> For now, I just tried the noatime mount option, I know there is a lot of 
> options, but I don't really understand what they stand for.
>
> Do you have any suggestion to make my filesystem safer ?
>
> Thanks
>
> Amandine
>
>

Put the system and array on a UPS.

There are also some other tweaks, but nothing is as important as putting 
it on a UPS.

Justin.
