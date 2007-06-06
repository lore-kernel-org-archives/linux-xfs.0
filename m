Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 22:55:08 -0700 (PDT)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l565t1Wt021651
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 22:55:03 -0700
Date: Wed, 6 Jun 2007 07:54:58 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: corruption bug in 2.6.17
In-Reply-To: <1181084327.3176.4.camel@edge.yarra.acx>
Message-ID: <alpine.DEB.0.99.0706060750100.21004@foobar-g4>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
 <alpine.DEB.0.99.0706022300140.16496@sheep.housecafe.de>
 <5d96567b0706050127y7f5eap7b92cddb5cdae02d@mail.gmail.com>
 <alpine.DEB.0.99.0706052217320.21004@foobar-g4>
 <1181084327.3176.4.camel@edge.yarra.acx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, xfs@oss.sgi.com

On Wed, 6 Jun 2007, Nathan Scott wrote:
> The problem was actually related to a particular form of btree
> dir2 transition - so, certain combinations of file names in a
> relatively large directory with size changes would trigger it.

Sorry, I did not intend to confuse. But all I noticed when the fs was 
shut down, was that a backup script was running and triggering the bug 
every morning. I was not aware of any large directories....

thanks,
Christian.
-- 
make bzImage, not war
