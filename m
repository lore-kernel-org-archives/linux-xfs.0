Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 05:19:21 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6ICJHbm004982
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 05:19:19 -0700
Date: Wed, 18 Jul 2007 08:19:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <20070718120922.GC8029@cumulus>
Message-ID: <Pine.LNX.4.64.0707180818520.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <20070718112612.GA8029@cumulus> <Pine.LNX.4.64.0707180734340.7659@p34.internal.lan>
 <20070718120922.GC8029@cumulus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sander <sander@humilis.net>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux@vger.kernel.org



On Wed, 18 Jul 2007, Sander wrote:

> Justin Piszcz wrote (ao):
>> On Wed, 18 Jul 2007, Sander wrote:
>>> Justin Piszcz wrote (ao):
>>>> Its too bad that there are no regular > 4 port SATA PCI-e controllers
>>>> out there.
>>>
>>> Is there a disadvantage to using a SaS controller from for example
>>> lsi.com ?
>>>
>>> http://lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/index.html
>>>
>>> I haven't tried them yet, but on paper it looks like an option, no?
>>
>> Hmm that is also a good idea- but I am afraid there could be a
>> similiar issue where it tries to do weird caching stuff, even when the
>> drives are in JBOD. Unless they offer a !raid SAS controller that
>> supports SATA drives.
>
> I guess they are cheap enough to try (I haven't yet):
>
> PCIe:
> http://lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3080xr/index.html
>
> PCI-X
> http://lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3081er/index.html
>
> All SaS hardware (controllers, chassis, etc) support SATA disks AFAIK.
>
> I have good experience with the Supermicro 8-Port SATA Card
> http://www.supermicro.nl/products/accessories/addon/AoC-SAT2-MV8.cfm
>
> But that is PCI-X while you requested PCIe.
>
> 	With kind regards, Sander
>
> -- 
> Humilis IT Services and Solutions
> http://www.humilis.net
>


Those links are reversed, but thanks, checking them out now!

Justin.
