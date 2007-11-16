Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Nov 2007 13:43:29 -0800 (PST)
Received: from smtp117.sbc.mail.sp1.yahoo.com (smtp117.sbc.mail.sp1.yahoo.com [69.147.64.90])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAGLhLIP018459
	for <linux-xfs@oss.sgi.com>; Fri, 16 Nov 2007 13:43:22 -0800
Date: Fri, 16 Nov 2007 13:43:27 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071116214327.GA9685@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de> <20071116003410.GA16797@puku.stupidest.org> <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org> <20071116110315.GA27969@puku.stupidest.org> <1195222772.7653.16.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195222772.7653.16.camel@heimdal.trondhjem.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com

On Fri, Nov 16, 2007 at 09:19:32AM -0500, Trond Myklebust wrote:

> Very funny, but disabling XFS on the client won't help.

Oops, I meant it for NFSD...  and I'm somewhat serious.  I'm not
saying it's a good long term solution, but a potentially safer
short-term workaround.
