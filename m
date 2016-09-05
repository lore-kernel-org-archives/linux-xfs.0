Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDCA27CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 09:58:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9DDCB304032
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 07:58:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id f9DBFPaMdQ4vd1y2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Sep 2016 07:58:09 -0700 (PDT)
Date: Mon, 5 Sep 2016 07:58:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] iomap: add a flag to report shared extents
Message-ID: <20160905145806.GD7662@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216788009.525.789325200721590680.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216788009.525.789325200721590680.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
