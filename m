Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 18:06:30 -0700 (PDT)
Received: from mx1.whoi.edu (zeratul.whoi.edu [128.128.76.62])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T16PMN003050
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 18:06:27 -0700
Date: Fri, 28 Sep 2007 21:06:22 -0400 (EDT)
From: Benjamin Carr <bcarr@whoi.edu>
Subject: Re: Truncated Filesystem
In-Reply-To: <46FDA35A.8040504@zytor.com>
Message-ID: <Pine.LNX.4.58.0709282105590.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
 <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net>
 <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
 <46FDA35A.8040504@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

> > sudo fdisk -l /dev/sdc1
>                 ^^^^^^^^^ Uh...

yeah, long day:

Disk /dev/sdc: 12999.9 GB, 12999988871168 bytes
255 heads, 63 sectors/track, 1580491 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      243744  1957867653+  83  Linux
