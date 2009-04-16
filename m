Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3G6878E050625 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 01:08:17 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC5748F80C6
	for <xfs@oss.sgi.com>; Wed, 15 Apr 2009 23:07:51 -0700 (PDT)
Message-Id: <C064E73A-BCB2-4F39-B271-F55E7212B6F5@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49E65044.8080802@tlinx.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: future of xfs, oss.sgi.com after sgi purchased?
Date: Thu, 16 Apr 2009 01:05:00 -0500
References: <49E65044.8080802@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Apr 15, 2009, at 4:23 PM, Linda A. Walsh wrote:

> Not one to beat about the bush, but curious from a practical sense,
>
> If sgi is being bought by another company, is there any idea about  
> the plans
> for the xfs file system or the source code on 'oss.sgi.com'?

The rumors of the death of xfs team at SGI are a little bit
premature.

> I'm _guessing_ that there is some interest in users and developers  
> to keep xfs alive after the 'sgi' moniker is purchased, but that  
> begs the question about the new company wanting to support the old  
> 'sgi.com' websites including
> oss.sgi.com.
>
> Is there a danger of oss.sgi.com suddenly being yanked offline with  
> little to no warning,

I doubt it'll happen in any circumstances.

> such that community members should start keeping up-to-date, or is  
> it already mirrored?  I'm assuming that the current source code  
> repository only exists on oss.sgi.com?

There is nothing on oss.sgi.com xfs-wise that is not in Linus' tree.

> Should it be mirrored on some other external open-source site?   
> sourceforge? google? mozilla?

With git you don't really need a true mirror. And official clones of
both kernel and the userland xfs already exist on kernel.org.

> Is completely worthless to discuss new, desired features in some of  
> the utils? Will it be possible to support the xfs codebase if its  
> development no longer becomes necessary to sgi (or its parent  
> company)?

I hope that wouldn't happen. Though, while it'll be loss for xfs
in this unlikely scenario, I think, there is enough critical mass
outside of sgi to continue support and move forward xfs.

Felix
xfs maintainer, still at sgi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
