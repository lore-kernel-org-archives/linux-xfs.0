Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB7JQDac030395 for <xfs@oss.sgi.com>; Sun, 7 Dec 2008 13:26:14 -0600
Received: from mail.harddata.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CF5AEFE068
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2008 11:26:04 -0800 (PST)
Received: from mail.harddata.com ([207.148.148.78]) by cuda.sgi.com with ESMTP
	id beHIAOzq3yVHlrTM for <xfs@oss.sgi.com>;
	Sun, 07 Dec 2008 11:26:04 -0800 (PST)
Message-ID: <493C1765.7070901@harddata.com>
Date: Sun, 07 Dec 2008 11:35:17 -0700
From: Maurice Hilarius <maurice@harddata.com>
MIME-Version: 1.0
Subject: Re: 3ware 9650SE-16ML w/XFS & RAID6: first impressions
References: <alpine.DEB.1.10.0812030930450.22299@p34.internal.lan>
	<200812071355.49427.hpj@urpla.net>
In-Reply-To: <200812071355.49427.hpj@urpla.net>
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hans-Peter Jansen wrote:
> Am Mittwoch, 3. Dezember 2008 schrieb Justin Piszcz:
>   
>> For read speed, it appears that there is some overhead (2x). With
>> software raid6 I used to get 1.0Gbyte/sec read speed, or at least
>> 800MiB/s across the entire array, now I only get 538MiB/s across the
>> entire array. However, write speed is improved. Before it was in the mid
>> 400s for RAID6 and peaking at 502MiB/s at the outer edge of the drives.
>> For the write speed now, its around 620-640MiB/s at the end of the array
>> and 580-620MiB/s going in further and 502MiB/s across the entire array. I
>> always heard all of the horror stories with 3ware cards, it turns out
>> they're not so bad after all.
>>     
>
> Hustin, if you're after speed, AND sane support, you may consider trying 
> Areca products. I'm biased, since 3ware fed me up completely, when it came 
> to a single drive failure in a RAID 5 setup: the support only provides an 
> ugly web interface: when posting my problem, they replied with:
>
>   
Nice Areca advertisement.

Of course you can demonstrate how their tech support responded, to a
similar DISK failure, with a better suggestion, and more promptly?

Buried for biased and irrelevant.


-- 
With our best regards,

//Maurice W. Hilarius         Telephone: 01-780-456-9771/
/Hard Data Ltd.                FAX:          01-780-456-9772/
/11060 - 166 Avenue         email:maurice@harddata.com/
/Edmonton, AB, Canada         http://www.harddata.com//
/     T5X 1Y3/
/


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
