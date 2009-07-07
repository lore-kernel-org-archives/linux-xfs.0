Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67H9965156892 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 12:09:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 043C81B00475
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 10:09:43 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id adcWsAUuoZ4vFRvU for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 10:09:43 -0700 (PDT)
Message-ID: <4A538157.8000704@sandeen.net>
Date: Tue, 07 Jul 2009 12:09:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix trivial typo in test 204 description
References: <20090707164038.GA9609@infradead.org>
In-Reply-To: <20090707164038.GA9609@infradead.org>
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
> 
> Index: xfstests-dev/204
> ===================================================================
> --- xfstests-dev.orig/204	2009-07-04 18:07:47.000000000 +0000
> +++ xfstests-dev/204	2009-07-04 18:07:51.000000000 +0000
> @@ -1,7 +1,7 @@
>  #! /bin/sh
>  # FS QA Test No. 204
>  #
> -# Test out ENOSPC flushiung on small filesystems.
> +# Test out ENOSPC flushing on small filesystems.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2009 Christoph Hellwig.
> 

Reviewed!  ;)

(that always bugged me!)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
