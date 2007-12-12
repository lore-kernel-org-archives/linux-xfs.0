Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 12:09:34 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBCK6JQx014720
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 12:06:23 -0800
Received: from astra.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2465B60151
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 12:06:19 -0800 (PST)
Received: from astra.telenet-ops.be (astra.telenet-ops.be [195.130.132.58]) by cuda.sgi.com with ESMTP id N8TAutOvpcOPuTWk for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 12:06:19 -0800 (PST)
Message-ID: <47603F1E.1090901@pandora.be>
Date: Wed, 12 Dec 2007 21:05:50 +0100
From: Denis Wegge <denis_wegge@pandora.be>
MIME-Version: 1.0
Subject: Re: XFS unable to mount, recover data
References: <475696D3.60007@pandora.be> <Pine.LNX.4.64.0712050745480.13960@p34.internal.lan> <475FA7B1.6070706@pandora.be> <Pine.LNX.4.64.0712120825540.3691@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0712120825540.3691@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

It was a Western Digital 320GB SATAII 16MB, WD3200KS-00PFB0 (don't 
remember the name of the model).


Justin Piszcz wrote:
> Just curious what brand/make/model was it that failed?
> 
> On Wed, 12 Dec 2007, Denis Wegge wrote:
> 
>> I tried putting it in the freezer, but that didn't help. Tests on
>> another computer also show that the hard drive cannot be accessed.
>>
>> It seems like the data on the disk is definitely lost. The disk,
>> however, has a 3 year warranty, so I'm going to return it.
>>
>> Thanks for your help.
>>
>> Denis
>>
>> Justin Piszcz wrote:
>>>
>>>
>>> On Wed, 5 Dec 2007, Denis Wegge wrote:
>>>
>>>> Hello
>>>>
>>>> I am having trouble with the XFS filesystem on a 320GB Western Digital
>>>> SATA harddisk. For no obvious reason the partition can no longer be
>>>> mounted. The following error occurs:
>>>>
>>>> knoppix@Knoppix:~$ sudo mount /dev/sda1 /mnt/sda1
>>>> mount: /dev/sda1: can't read superblock
>>>
>>> Looks like your disk is dying or dead from your logs.  You can try 
>>> putting it
>>> in a plastic airtight bag then put it in the freezer and try again but
>>> otherwise if that does not work, its time for the trash bin (after 
>>> you try)
>>> a dd and overwrite the disk but with that many bad sectors it looks like
>>> it has really gone south.
>>>
>>> Insert new disk, restore from backup.
>>>
>>> Justin.
>>>
>>>
>>>
>>
>>
> 
> 
