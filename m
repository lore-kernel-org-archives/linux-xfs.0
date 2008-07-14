Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jul 2008 21:14:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6E4EOIq015959
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 21:14:25 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2C24E0884E
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 21:15:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id FONojpJFcV6kgk0U for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 21:15:30 -0700 (PDT)
Message-ID: <487AD2E1.6030704@sandeen.net>
Date: Sun, 13 Jul 2008 23:15:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs leaking?
References: <4877928A.1020008@sandeen.net> <20080711233832.GH11558@disturbed> <4877FC4F.7020906@sandeen.net> <487810BE.5050701@sandeen.net> <487AD102.9020306@sgi.com>
In-Reply-To: <487AD102.9020306@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:
> 
> Eric Sandeen wrote:
>> 2.6.26-rc9 passed without incident.
> 
> So what is the conclusion here? Because you just down-rev? Or do we have
> an intermittent leak of some kind?

haven't yet re-tested on -rc2... not 100% sure yet.  So far I'd be
willing to chalk it up to something wrong in -rc2.

-Eric
