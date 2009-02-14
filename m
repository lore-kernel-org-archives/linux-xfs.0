Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1EJgfcu011480 for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 13:42:41 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D58912068A
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 11:42:06 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Vg9tYUQi7BSuaZWH for <xfs@oss.sgi.com>;
	Sat, 14 Feb 2009 11:42:06 -0800 (PST)
Message-ID: <499717D4.6090404@sandeen.net>
Date: Sat, 14 Feb 2009 13:13:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix comment typos in test 201
References: <20090214163917.GA19813@infradead.org>
In-Reply-To: <20090214163917.GA19813@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

ACK

> Index: xfstests-dev/201
> ===================================================================
> --- xfstests-dev.orig/201	2009-02-14 15:06:31.000000000 +0000
> +++ xfstests-dev/201	2009-02-14 15:06:42.000000000 +0000
> @@ -1,13 +1,13 @@
>  #! /bin/sh
>  # FS QA Test No. 201
>  #
> -# Test out the infamout xfs_btree_delrec corruption.
> +# Test out the infamous xfs_btree_delrec corruption.
>  #
>  # Only happens on 32-bit kernels without CONFIG_LBD, but it should be harmless
>  # to run this everywhere.
>  #
>  #-----------------------------------------------------------------------
> -# Copyright (c) 2001 Christoph Hellwig.
> +# Copyright (c) 2009 Christoph Hellwig.
>  #-----------------------------------------------------------------------
>  #
>  # creator
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
