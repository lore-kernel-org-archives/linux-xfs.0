Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9Daql7156391 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 07:36:52 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E2401C280B2
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 05:38:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pWA3Kos4jXvtSOPX for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 05:38:19 -0800 (PST)
Date: Tue, 9 Nov 2010 08:38:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: fix debian upgrade issue
Message-ID: <20101109133818.GA2066@infradead.org>
References: <1189766076.18791289303743211.JavaMail.root@acxmail-au2.aconex.com>
	<1431731622.18831289303817979.JavaMail.root@acxmail-au2.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1431731622.18831289303817979.JavaMail.root@acxmail-au2.aconex.com>
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
To: nathans@debian.org
Cc: xfs <xfs@oss.sgi.com>

On Tue, Nov 09, 2010 at 10:56:58PM +1100, nathans@debian.org wrote:
> Fix xfs_estimate issue upgrading xfsprogs/xfsdump from lenny
>     
> Fix bug "xfsprogs: file conflict when upgrading from lenny":
> add 'Replaces: xfsdump (<< 3.0.0); thanks to Vagrant Cascadian
> for the analysis.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
