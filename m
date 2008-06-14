Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jun 2008 09:52:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5EGqYWM023732
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:52:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26A95CBA819
	for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:53:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yB5lX6i93NLE0QbC for <xfs@oss.sgi.com>; Sat, 14 Jun 2008 09:53:31 -0700 (PDT)
Message-ID: <4853F78A.1060605@sandeen.net>
Date: Sat, 14 Jun 2008 11:53:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: GRIO for Linux...please!
References: <4853CC74.8040206@verizon.net>
In-Reply-To: <4853CC74.8040206@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Littell <littelld@verizon.net>
Cc: xfs@oss.sgi.com

Dave Littell wrote:
> Hi all,
> 
> Is there any plan (or even hope!) to have GRIO ported to Linux?  XFS is
> an excellent filesystem in any case, but GRIO would put it head and
> shoulders above the competition.

GRIOV1 was a highly irix-specific beast... GRIOV2 was quite different,
and available on linux but AFAIK there were never any plans to make it GPL.

Doesn't hurt to ask I suppose.  :)

You do have the realtime subvolume on linux, though, which was
originally a component of GRIOV1.

-Eric


> 
> Thanks,
> Dave
> 
> 
