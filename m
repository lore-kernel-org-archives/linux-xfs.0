Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEHU6f164895 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:17:30 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F1DB24C9D9
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:17:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XNXSnBG9jb7UC3G1 for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:17:30 -0700 (PDT)
Message-ID: <49F86178.8050101@sandeen.net>
Date: Wed, 29 Apr 2009 09:17:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] dmapi: bump version and update CHANGES
References: <20090429134940.GA30808@infradead.org>
In-Reply-To: <20090429134940.GA30808@infradead.org>
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
> Index: dmapi-dev/VERSION
> ===================================================================
> --- dmapi-dev.orig/VERSION	2009-04-29 15:35:03.447607212 +0200
> +++ dmapi-dev/VERSION	2009-04-29 15:35:06.731519494 +0200
> @@ -3,5 +3,5 @@
>  #
>  PKG_MAJOR=2
>  PKG_MINOR=2
> -PKG_REVISION=9
> +PKG_REVISION=10
>  PKG_BUILD=1
> Index: dmapi-dev/doc/CHANGES
> ===================================================================
> --- dmapi-dev.orig/doc/CHANGES	2009-04-29 15:35:10.867482929 +0200
> +++ dmapi-dev/doc/CHANGES	2009-04-29 15:36:03.542550769 +0200
> @@ -1,3 +1,8 @@
> +dmapi-2.2.10
> +	- Update the Makepkgs script to generate proper source tarballs.
> +	- Small specfile improvements, thanks to Jan Engelhardt.
> +	- Various autoconf/libtool fixes, thanks to Andreas Gruenbacher.
> +
>  dmapi-2.2.9 (4 February 2009)
>  	- Various build system updates.
>  

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
