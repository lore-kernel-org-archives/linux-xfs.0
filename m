Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:51:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NphAE025758
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:51:45 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E368373BE11
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 16:52:20 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id umJnvYoMnFugqv62 for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 16:52:20 -0700 (PDT)
Subject: Re: xfs_check running out of memory
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4f52331f0804031623hc880b03i90f1eed342e97f3c@mail.gmail.com>
References: <4f52331f0804031556n1f00e435g3273c516aacc5d95@mail.gmail.com>
	 <1207263793.21048.150.camel@edge.scott.net.au>
	 <4f52331f0804031611u30e706ddk10aa7a4d011df6a2@mail.gmail.com>
	 <1207264560.21048.153.camel@edge.scott.net.au>
	 <4f52331f0804031623hc880b03i90f1eed342e97f3c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 10:33:38 +1100
Message-Id: <1207265618.21048.159.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Fong Vang <sudoyang@gmail.com>
Cc: xfs@oss.sgi.com


On Thu, 2008-04-03 at 16:23 -0700, Fong Vang wrote:
> 
> 
> 
> 
> good to know.  Doesn't xfs_check also repair?  with xfs_repair -n,

No, it doesn't.

>  this doesn't do any repair.  SO the right approach on big volumes
> would be to run xfs_repair -n first to detect problem then xfs_repair
> to fix?

Sure - whatever floats your boat.

> thank you for the info.  much appreciated.  just, curious.  where did
> you get this info?

>From the source.

cheers.

-- 
Nathan
