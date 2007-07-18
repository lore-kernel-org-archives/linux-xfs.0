Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 05:01:17 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IC1Dbm029001
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 05:01:15 -0700
Date: Wed, 18 Jul 2007 08:01:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID5 Horrible Write Speed On 3ware Controller!!
In-Reply-To: <200707181359.21710.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0707180800280.7659@p34.internal.lan>
References: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
 <200707181359.21710.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Al Boldi wrote:

> Justin Piszcz wrote:
>> UltraDense-AS-3ware-R5-9-disks,16G,50676,89,96019,34,46379,9,60267,99,5010
>> 98,56,248.5,0,16:100000:16/64,240,3,21959,84,1109,10,286,4,22923,91,544,6
>> UltraDense-AS-3ware-R5-9-disks,16G,49983,88,96902,37,47951,10,59002,99,529
>> 121,60,210.3,0,16:100000:16/64,250,3,25506,98,1163,10,268,3,18003,71,772,8
>> UltraDense-AS-3ware-R5-9-disks,16G,49811,87,95759,35,48214,10,60153,99,538
>> 559,61,276.8,0,16:100000:16/64,233,3,25514,97,1100,9,279,3,21398,84,839,9
>
> Is there any easy way to decipher these numbers?
>
>
> Thanks!
>
> --
> Al
>
>

Yeah, I put them in that format so people crawling the mailing list later 
could re-produce the HTML version:

cat that_file_containing_that_output | /usr/bin/bon_csv2html > out.html

Justin.
