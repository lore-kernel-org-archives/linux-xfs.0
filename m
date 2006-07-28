Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 14:49:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6SLmqDW030596
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 14:49:04 -0700
Date: Sat, 29 Jul 2006 07:48:03 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060729074803.A2222647@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607221722500.8407@prinz64.housecafe.de> <20060724090138.C2083275@wobbly.melbourne.sgi.com> <Pine.LNX.4.64.0607281526220.1882@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607281526220.1882@sheep.housecafe.de>; from evil@g-house.de on Fri, Jul 28, 2006 at 05:01:24PM +0000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <evil@g-house.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 28, 2006 at 05:01:24PM +0000, Christian Kujau wrote:
> I had two xfs filesystems and I first noticed that /data/Scratch was 
> befallen from this bug. I did not care much about this (hence the
> name :)) and I wanted to postpone the xfs_db surgery.
> ...
> found more and more errors. I decided to mkfs the partition and make use 
> of my backups. my other "scratch" partition is still XFS but mounted ro 
> and I'll try the xfsprogs fixes Nathan published on this one.

Barry sent an xfs_repair patch to resolve this issue to the xfs@oss.sgi.com
list yesterday; please give that a go and let us know how it fares.

cheers.

-- 
Nathan
