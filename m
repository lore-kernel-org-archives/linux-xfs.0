Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Nov 2007 01:17:38 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAG9HVrG016988
	for <linux-xfs@oss.sgi.com>; Fri, 16 Nov 2007 01:17:33 -0800
Message-ID: <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
In-Reply-To: <20071116003410.GA16797@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org>
    <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
    <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
    <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
    <20071116003410.GA16797@puku.stupidest.org>
Date: Fri, 16 Nov 2007 10:17:17 +0100 (CET)
Subject: Re: 2.6.24-rc2 XFS nfsd hang
From: "Christian Kujau" <lists@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com

On Fri, November 16, 2007 01:34, Chris Wedgwood wrote:
> I'm not sure what you're doing here, but a viable work-around for now
> might be to use nfsv2 mounts, something like
>
> mount -o vers=2 ...
> or to keep v3 and disable readdirplus doing something like:
> mount -o vers=3,nordirplus ...

OK, I'll try this. I hope this can be fixed somehow before 2.6.24...

Thank you for your time,
Christian.
-- 
BOFH excuse #442:

Trojan horse ran out of hay
