Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 09:48:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l45GlxfB005748
	for <linux-xfs@oss.sgi.com>; Sat, 5 May 2007 09:48:00 -0700
Message-ID: <463CB53E.8000202@sandeen.net>
Date: Sat, 05 May 2007 11:47:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com>	<20070504073344.GL32602149@melbourne.sgi.com>	<20070504152546.614374ac@harpe.intellique.com>	<200705041758.21320.Martin@lichtvoll.de>	<20070504234357.24d22883@galadriel.home>	<463C0CD8.4090402@sandeen.net> <20070505171820.6e92d437@galadriel.home>
In-Reply-To: <20070505171820.6e92d437@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

Emmanuel Florac wrote:
> Le Fri, 04 May 2007 23:49:28 -0500 vous écriviez:
> 
>> Most recent kernels (2.6.19 or so IIRC) & cvs e2fsprogs (or that from 
>> rhel5/centos5) can do up to 16T ext3 filesystems, so you should be
>> able to test that if you like.
> 
> Thanks, I'll try that too. Though it won't cover all my needs (I plan
> to set up 50 and 150TB systems really soon).
> 

Sure, I understand - it may be helpful in figuring out what the problem 
is, though.  I'll be curious to see how it goes...

Oh, btw, you'll need the -F (force) flag for mkfs.ext3

-Eric
