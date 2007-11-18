Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Nov 2007 07:31:26 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAIFVJPt014723
	for <linux-xfs@oss.sgi.com>; Sun, 18 Nov 2007 07:31:20 -0800
Date: Sun, 18 Nov 2007 10:31:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
In-Reply-To: <alpine.DEB.0.99999.0711181541280.30603@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.64.0711181031110.29571@p34.internal.lan>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com>
 <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
 <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
 <20071116003410.GA16797@puku.stupidest.org>
 <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
 <20071116110315.GA27969@puku.stupidest.org> <1195222772.7653.16.camel@heimdal.trondhjem.org>
 <20071116214327.GA9685@puku.stupidest.org> <alpine.DEB.0.99999.0711181541280.30603@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: Chris Wedgwood <cw@f00f.org>, Trond Myklebust <trond.myklebust@fys.uio.no>, LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com



On Sun, 18 Nov 2007, Christian Kujau wrote:

> On Fri, 16 Nov 2007, Chris Wedgwood wrote:
>> Oops, I meant it for NFSD...  and I'm somewhat serious.  I'm not
>> saying it's a good long term solution, but a potentially safer
>> short-term workaround.
>
> I've opened http://bugzilla.kernel.org/show_bug.cgi?id=9400 to track this one 
> (and to not forget about it :)).
>
> I wonder why so few people are seeing this, I'd have assumed that
> NFSv3 && XFS is not sooo exotic...
Still on 2.6.23.x here (also use nfsv3 + xfs).

>
> Christian.
> -- 
> BOFH excuse #273:
>
> The cord jumped over and hit the power switch.
>
>
