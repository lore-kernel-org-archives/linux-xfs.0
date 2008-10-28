Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 19:17:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S2Gv2p000319
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:16:58 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 399A41495725
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:16:56 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id ZyQa614F02ecdw7F for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:16:56 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kue8a-0003sD-Ht
	for linux-xfs@oss.sgi.com; Tue, 28 Oct 2008 02:16:52 +0000
Received: from 75-134-105-39.dhcp.aldl.mi.charter.com ([75.134.105.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:16:52 +0000
Received: from mlueck by 75-134-105-39.dhcp.aldl.mi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:16:52 +0000
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: Bad day with xfsrestore, what went wrong?
Date: Mon, 27 Oct 2008 22:16:47 -0400
Message-ID: <ge5sm7$i1g$1@ger.gmane.org>
References: <gde1k2$gkp$1@ger.gmane.org> <ge38k5$qf$1@ger.gmane.org> <49063F75.7000604@sgi.com> <ge5kle$ueo$1@ger.gmane.org> <49067479.6070604@sgi.com>
Reply-To: mlueck@lueckdatasystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <49067479.6070604@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Timothy Shimmin wrote:
> Maybe the -E option helped you out there.
> 
>   -E   Prevents  xfsrestore from overwriting newer versions of files.  

fffffeeeeeeeewwwwwwwwww!!!!!!!!!!! :-)

Thank you Tim! You put a smile on my face.

I worked out that syntax about 5 years ago, keep it in a text file, update as needed, and paste it into an SSH session. That is why I was so surprised that "something" went wrong.

Thanks again!

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/
