Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 09:37:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BGbSaG023993
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 09:37:29 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94934D190490
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 09:36:46 -0700 (PDT)
Message-ID: <452D1D9B.7060302@sandeen.net>
Date: Wed, 11 Oct 2006 11:36:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Software raid 5 with XFS causing strange lockup problems
References: <acd894d40610102307n7fd07108u67d1b1015eeeb594@mail.gmail.com>	 <452CF770.5050902@sandeen.net> <acd894d40610110921j61bcf5cdn57887c386f54f6c8@mail.gmail.com>
In-Reply-To: <acd894d40610110921j61bcf5cdn57887c386f54f6c8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ian Williamson <notian@gmail.com>
Cc: xfs@oss.sgi.com

Ian Williamson wrote:
> Eric,
> That's all I have for the event in /var/log/messages..

Weird.  I don't even know if that's an oops or if so why, it's just a
backtrace.

Does your kernel have 4k stacks?

-Eric
