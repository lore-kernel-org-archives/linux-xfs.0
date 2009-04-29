Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3TEgav7165622 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 09:42:37 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B3CAAC004
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 07:42:37 -0700 (PDT)
Message-Id: <04552742-BF7F-4F94-A658-1307A0C2D6A7@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090429134940.GA30808@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] dmapi: bump version and update CHANGES
Date: Wed, 29 Apr 2009 09:42:35 -0500
References: <20090429134940.GA30808@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Apr 29, 2009, at 8:49 AM, Christoph Hellwig wrote:

> Index: dmapi-dev/VERSION
> ===================================================================
> --- dmapi-dev.orig/VERSION	2009-04-29 15:35:03.447607212 +0200
> +++ dmapi-dev/VERSION	2009-04-29 15:35:06.731519494 +0200
> @@ -3,5 +3,5 @@
> #
> PKG_MAJOR=2
> PKG_MINOR=2
> -PKG_REVISION=9
> +PKG_REVISION=10
> PKG_BUILD=1
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
> dmapi-2.2.9 (4 February 2009)
> 	- Various build system updates.


Acked-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
