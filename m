Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 08:24:06 -0800 (PST)
Received: from mail.groll.co.za (mail.groll.co.za [67.18.176.185])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kANGNwaG009586
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 08:23:59 -0800
Date: Thu, 23 Nov 2006 15:14:05 +0200
From: Jonathan Groll <lists@groll.co.za>
Subject: Re: Unexpected inode type 0160000 causes abort of xfs_repair
Message-ID: <20061123131405.GA27453@groll.co.za>
References: <20061122201131.GD2493@groll.co.za> <200611230047.LAA09023@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200611230047.LAA09023@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>, xfs@oss.sgi.com

On Thu, Nov 23, 2006 at 11:51:11AM +1100, Barry Naujok wrote:
> Can you try the attached patch and see how xfs_repair goes? 

Many thanks, the patch worked like a charm! Is it going to be
incorporated into the package in future?

Luckily I didn't have to blast the inode away, but I suspect that is
exactly what the effect of the patch was ;-)

Thanks again,
Jonathan
