Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 10:15:26 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB5IFHaG010040
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 10:15:19 -0800
Date: Tue, 5 Dec 2006 17:46:15 +0000 (GMT)
From: Christian Kujau <christian@nerdbynature.de>
Subject: Re: mkfs.xfs questions
In-Reply-To: <20061202111546.GA18661@teal.hq.k1024.org>
Message-ID: <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch>
 <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
 <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de>
 <20061202111546.GA18661@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Iustin Pop <iusty@k1024.org>
Cc: xfs@oss.sgi.com, jasmin@pacifica.ch

On Sat, 2 Dec 2006, Iustin Pop wrote:
> Hmm, I am pretty sure that it makes a difference, but only from personal
> experience, not from benchmarks. A while ago, mkfs.xfs used to make <8M
> logs even for big filesystems[0]. Nowadays it chooses a more sane value.

I could not stand my own curiosity, so here it is: 
http://nerdbynature.de/wp/?cat=4

I think I'll repeat the benchmarks with bigger test sizes. The 
testscript can easily be adjusted to test more options/values.

Christian.
-- 
BOFH excuse #248:

Too much radiation coming from the soil.
