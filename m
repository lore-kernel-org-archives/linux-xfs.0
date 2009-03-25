Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2PCFTX4091756
	for <linux-xfs@oss.sgi.com>; Wed, 25 Mar 2009 07:15:39 -0500
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC9D01C6CB06
	for <linux-xfs@oss.sgi.com>; Wed, 25 Mar 2009 05:14:42 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.251]) by cuda.sgi.com with ESMTP id
	irtvrkeZuYWgFJgH for <linux-xfs@oss.sgi.com>;
	Wed, 25 Mar 2009 05:14:42 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id b2so904ana.5
	for <linux-xfs@oss.sgi.com>; Wed, 25 Mar 2009 05:14:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87hc1iemo4.fsf@frosties.localdomain>
References: <174852.24274.qm@web51309.mail.re2.yahoo.com>
	<87hc1iemo4.fsf@frosties.localdomain>
Date: Wed, 25 Mar 2009 05:14:42 -0700
Message-ID: <c268e4660903250514y12babcc5hf42f4d3daff3fa45@mail.gmail.com>
Subject: Re: How to configure 36 disks ?
From: Drew <drew.kay@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Jon@ehardcastle.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-aio@kvack.org, linux-xfs@oss.sgi.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Raz <raziebe@gmail.com>, linux-fsdevel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>

>> I'd like to understand how you even go attaching that many devices to a system.. I am 'comparatively'
>> new to this.. and have a 6 raid5 system.. not enterprise.. and i have slammed into case/power/sat slot
>> issues already. What sort of hardware must one use to grow to a 36 array system!
>
> Well, lets see.
>
> Put 3 dual channel SAS controler in the box giving you 6 external SAS
> connectors. Buy 6 48x disk enclosures and connect them. Configure them
> all as JBOD and you get your 288 disks.

And after you've mortgaged your house, your future, and your first born ... :-P


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
