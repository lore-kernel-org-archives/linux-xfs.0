Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Nov 2006 11:02:53 -0800 (PST)
Received: from megapolis.pl (mail.megapolis.pl [193.218.115.19])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kASJ2jaG032447
	for <linux-xfs@oss.sgi.com>; Tue, 28 Nov 2006 11:02:46 -0800
Message-ID: <456C7927.6070501@wp.pl>
Date: Tue, 28 Nov 2006 19:00:07 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
MIME-Version: 1.0
Subject: Re: Errors on XFS partition - ask for diagnose
References: <ekcvdq$4g1$1@sea.gmane.org> <456AA1D4.6020303@melbourne.sgi.com>
In-Reply-To: <456AA1D4.6020303@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: linux-xfs@oss.sgi.com

On 2006-11-27 9:29:08 +0100, David Chatterton wrote:
> See:
> http://oss.sgi.com/projects/xfs/faq.html#dir2

Thanks, I had 2.6.17 kernel those days.
I'll try to get xfs_repair >= 2.8.10 for SystemRescueCD which I use and 
try repair file system.


Regards
Marcin


> Marcin Zaj±czkowski wrote:
>> Hi,
>>
>>
>> Recently some of my executable files (on XFS partition) have become
>> "invisible" for whereis, locate, find, bash, mc, nautilus and others.
>> They are not reported by autofill in bash, but I can run it by typing
>> full file name. "ls" with full name returns info about file, "ls" with
>> regexp no.
>>
>> I run xfs_check and it returned me many errors (see below).
>>
>> Because I don't have experience with errors on XFS partition I would
>> like to ask, do you think that after ran of xfs_repair file system would
>> be still usable (now only those files are invisible, but still accessible)?
>>
>>
>> Btw, I didn't have any power failure, nor problems with hardware (at
>> least on this partition - based on smart report). The trigger for that
>> was to fill in partition in 100%. Could it cause those error on my
>> partition?
(...)
