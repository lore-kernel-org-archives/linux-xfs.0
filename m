Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Oct 2008 08:38:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9OFc3U2018106
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 08:38:03 -0700
Message-ID: <4901EBD6.4070306@sandeen.net>
Date: Fri, 24 Oct 2008 10:37:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS performance tracking and regression monitoring
References: <490108E6.7060502@sgi.com> <20081024035411.GH18495@disturbed>
In-Reply-To: <20081024035411.GH18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:

> Perhap you might want to look more closely at FFSB - it has a
> fairly interesting automated test harness. e.g. it was used to
> produce these:
> 
> http://btrfs.boxacle.net/
> 
> And you can probably set up custom workloads to cover all the things
> that the standard benchmarks do.....

I was going to suggest that too, those are some nifty charts.  :)

ffsb takes workload recipes so you can make it do a large variety of
things...

-Eric
