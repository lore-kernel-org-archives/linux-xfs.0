Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 06:44:30 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAFEiM27009164
	for <linux-xfs@oss.sgi.com>; Thu, 15 Nov 2007 06:44:24 -0800
Message-ID: <23908.62.180.231.196.1195137856.squirrel@housecafe.dyndns.org>
In-Reply-To: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org>
    <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
    <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
    <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
Date: Thu, 15 Nov 2007 15:44:16 +0100 (CET)
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
From: "Christian Kujau" <lists@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain;charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com

On Thu, November 15, 2007 08:51, Christian Kujau wrote:
> Since NFS was not working (the nfsd processes were already in D state),
> to mount a CIFS share from the very same server (and the same client).

That should read:

Since NFS was not working (the nfsd processes were already in D state), I
decided to mount a CIFS share from the very same server (and the same
client). [...]

C.
-- 
BOFH excuse #442:

Trojan horse ran out of hay
