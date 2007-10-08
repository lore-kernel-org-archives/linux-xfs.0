Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 17:45:20 -0700 (PDT)
Received: from smtp124.sbc.mail.sp1.yahoo.com (smtp124.sbc.mail.sp1.yahoo.com [69.147.64.97])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l980jEmV024200
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 17:45:15 -0700
Date: Sun, 7 Oct 2007 17:45:13 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: mounting raid5 with different unit values
Message-ID: <20071008004513.GA13543@puku.stupidest.org>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com> <20071007145213.GA4504@puku.stupidest.org> <Pine.LNX.4.64.0710071147390.22702@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710071147390.22702@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Raz <raziebe@gmail.com>, linux-xfs@oss.sgi.com

On Sun, Oct 07, 2007 at 11:48:14AM -0400, Justin Piszcz wrote:

> man mount :)

Ah of course.

But those will be more restrictive that what you can specify when you
make the file-system (because mkfs.xfs can aligned the AGs to suit).
