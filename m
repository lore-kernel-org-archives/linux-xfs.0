Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 00:25:11 -0700 (PDT)
Received: from the-village.bc.nu (outpipe-village-512-1.bc.nu [81.2.110.250] (may be forged))
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T7OuHC009549
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 00:25:00 -0700
Date: Sat, 29 Sep 2007 07:26:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Truncated Filesystem
Message-ID: <20070929072653.4e706888@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
	<Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
	<46FD9006.6050807@sandeen.net>
	<46FD959E.5030009@zytor.com>
	<Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Benjamin Carr <bcarr@whoi.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 20:49:12 -0400 (EDT)
Benjamin Carr <bcarr@whoi.edu> wrote:

> > What kind of partition table is it?  MS-DOS partition tables have a 2 TB
> > limit.
> 
> Hadn't thought of that, doesn't look good.
> -Ben
> 
> sudo fdisk -l /dev/sdc1
> benc's password:

That would be on /dev/sdc surely ?
