Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19AY8pJ240559
	for <linux-xfs@oss.sgi.com>; Mon, 9 Feb 2009 04:34:08 -0600
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6969EFD812
	for <linux-xfs@oss.sgi.com>; Mon,  9 Feb 2009 02:33:31 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ht8mzNIL8tDsLAlY for
	<linux-xfs@oss.sgi.com>; Mon, 09 Feb 2009 02:33:31 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1234135463.12370.47.camel@champagne.cantina>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208221625.GB8830@disturbed>
	<1234135463.12370.47.camel@champagne.cantina>
Date: Mon, 09 Feb 2009 11:33:27 +0100
Message-Id: <1234175607.5951.76.camel@laptop>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2009-02-09 at 00:24 +0100, Alessandro Bono wrote:
> In the past I lose configuration files from kde, gconf based programs
> (gnome), pan, firefox, etc
> maybe xfs expose more this problem  

>From what I heard Linux userspace is on crack and thinks it can get away
without calling fsync().



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
