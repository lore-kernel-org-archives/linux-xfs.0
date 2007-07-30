Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jul 2007 21:22:43 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6U4Mdbm005139
	for <xfs@oss.sgi.com>; Sun, 29 Jul 2007 21:22:40 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IFMXa-0001xU-7x
	for xfs@oss.sgi.com; Sun, 29 Jul 2007 21:07:30 -0700
Message-ID: <11857832.post@talk.nabble.com>
Date: Sun, 29 Jul 2007 21:07:30 -0700 (PDT)
From: richid <rich.schu@gmail.com>
Subject: Re: XFS crash on linux raid
In-Reply-To: <20070507120754.289deffd@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <20070507021122.GQ32602149@melbourne.sgi.com> <20070507120754.289deffd@galadriel.home>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com




Emmanuel Florac wrote:
> 
> Le Mon, 7 May 2007 12:11:22 +1000 vous écriviez:
> 
>> So you use software raid and you get corruptions, right? I doubt this
>> has anything to do with write barriers - if it does thats an
>> indication of broken drivers or hardware.....
>> 
>> Can you run with "-o nobarrier" and no software raid and see if you
>> still have a problem?
> 
> I tried on the same machine without software RAID and barriers, and i
> worked OK. I'll try today with nobarrier. Stay tuned :)
> 
> -- 
> --------------------------------------------------
> Emmanuel Florac               www.intellique.com   
> --------------------------------------------------
> 

Can you update us on the status?  Not to thread hijack, but I am having the
same problem on my fileserver.  Searched all over and can't seem to find a
definitive answer.

-- 
View this message in context: http://www.nabble.com/XFS-crash-on-linux-raid-tf3687076.html#a11857832
Sent from the Xfs - General mailing list archive at Nabble.com.
