Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 12:28:22 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l83JSI4p009335
	for <linux-xfs@oss.sgi.com>; Mon, 3 Sep 2007 12:28:20 -0700
Received: from [89.54.161.50] (helo=[192.168.178.25])
	by mail.g-house.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <lists@nerdbynature.de>)
	id 1ISH52-0003S2-DN
	for linux-xfs@oss.sgi.com; Mon, 03 Sep 2007 20:55:25 +0200
Date: Mon, 3 Sep 2007 20:55:19 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: raid50 and 9TB volumes
In-Reply-To: <5d96567b0709030724w3098395bnbd511fa3819e5b22@mail.gmail.com>
Message-ID: <alpine.DEB.0.999.0709032053290.7103@sheep.housecafe.de>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
 <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
 <20070716221831.GE31489@sgi.com>  <18076.1449.138328.66699@notabene.brown>
  <20070717001205.GI31489@sgi.com>  <18076.4940.845633.149160@notabene.brown>
  <20070717005854.GL31489@sgi.com>  <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>
  <20070724010105.GN31489@sgi.com>  <5d96567b0708070220u23c895ffk54849fca947b5100@mail.gmail.com>
 <5d96567b0709030724w3098395bnbd511fa3819e5b22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Mon, 3 Sep 2007, Raz wrote:
> What is the curret status of this problem ? If you recall , xfs in 32bit
> over 10 TB md device ( raid50 in this case) sees only 8TB ( and no more).
> The disks I am using are 750GB hitachi.
> kernel is 2.6.17.

dunno about this particular issue, but you meant "kernel 2.6.17.7 or 
higher", right? If not: http://oss.sgi.com/projects/xfs/faq.html#dir2

-- 
BOFH excuse #374:

It's the InterNIC's fault.
