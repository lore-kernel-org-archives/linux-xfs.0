Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:01:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B4185Z010415
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:01:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 700FDDF4EB8
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:02:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id iH0IUhP3SQ03KDHl for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:02:13 -0700 (PDT)
Message-ID: <4876DB44.7020905@sandeen.net>
Date: Thu, 10 Jul 2008 23:02:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <20080711032258.GB11558@disturbed> <4876D872.2060408@sgi.com>
In-Reply-To: <4876D872.2060408@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:

> At this stage, I think it would be safest to back-out the commit,
> all the way to mainline. Tim, can you please work thru that today
> with priority.

how 'bout I test my testcase w/ the patch removed to at least be sure
that's it.  :)

Then maybe we can see if Dave, having been alerted to the problem, has a
notion of how to fix it?

-Eric
