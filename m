Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 18:11:23 -0700 (PDT)
Received: from home.jason.bur.st (ppp76-251.lns1.mel3.internode.on.net [59.167.76.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2H1BF6p024226
	for <linux-xfs@oss.sgi.com>; Fri, 16 Mar 2007 18:11:17 -0700
Date: Sat, 17 Mar 2007 11:47:31 +1100
From: Jason White <jasonjgw@internode.on.net>
Subject: Re: Questions about XFS
Message-ID: <20070317004731.GA5236@jdc.local>
References: <200703131440.56678.clflush@chello.be> <45F8CAEA.3050408@list.rakugaki.org> <200703151007.32630.clflush@chello.be> <200703161136.32234.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703161136.32234.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Mar 16, 2007 at 11:36:31AM +0100, Martin Steigerwald wrote:
 
> Since 2.6.17.7 and enabled write barriers I didn't loose meta data 
> consistency on my laptop anymore and I can tell you that it crashed a lot 
> due to my experiments with what not (especially OSS radeon drivers and 
> beryl;-). I also had some classical power outages. 

My laptop also supports write barriers, but I leave the battery in place in
case there's a power outage; effectively it's operating as a UPS.

This might be slightly off-topic, but in choosing a SATA drive for a desktop
machine, what features/standard-complaince should one look for in order to
ensure that write barriers work? I know this involves flushing the drive
cache, but is this support mandatory in any of the applicable standards?
