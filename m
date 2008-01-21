Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 17:09:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L190UD023051
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 17:09:03 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B2AFCA9A3C
	for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 17:09:17 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id yKVsTUXThZYAnAq9 for <linux-xfs@oss.sgi.com>; Sun, 20 Jan 2008 17:09:17 -0800 (PST)
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.t489bqii3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <200801181905.05263.Martin@lichtvoll.de>
	 <1200868214.9463.274.camel@edge.scott.net.au>
	 <op.t489bqii3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 12:12:21 +1100
Message-Id: <1200877941.9463.292.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

On Mon, 2008-01-21 at 12:05 +1100, Barry Naujok wrote:
> 
> 
> 
> 
> On Mon, 21 Jan 2008 09:30:14 +1100, Nathan Scott <nscott@aconex.com>
> wrote:
> 
> > On Fri, 2008-01-18 at 19:05 +0100, Martin Steigerwald wrote:
> >
> >> can switch between enable / disable case-insensitivity via a mount
> >> option.
> >
> > No.
> 
> Umm, that's a yes :)

Ahem, you snipped the context precending that question!
Surely you can't switch, unless the case-insensitive mkfs option was
used initially...?  (unlike, say attr2, which can be enabled on-the-fly
with a mount option, on existing attr1 filesystems).

cheers.

-- 
Nathan
