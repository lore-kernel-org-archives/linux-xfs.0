Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 08:19:02 -0700 (PDT)
Received: from smtp115.sbc.mail.sp1.yahoo.com (smtp115.sbc.mail.sp1.yahoo.com [69.147.64.88])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l97FIt4J020223
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 08:18:59 -0700
Date: Sun, 7 Oct 2007 07:52:13 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: mounting raid5 with different unit values
Message-ID: <20071007145213.GA4504@puku.stupidest.org>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Sun, Oct 07, 2007 at 09:15:23AM +0200, Raz wrote:

> mount -osunit=6144,swidth=18432 /dev/md1 /d1/

those values are set when you make the filesystem, not mount it

see the mkfs.xfs man page
