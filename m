Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6084D29DFB
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 05:40:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D2A0304039
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 03:40:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ai2SeOu4w9ht0DDG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 03:40:07 -0700 (PDT)
Date: Mon, 29 Sep 2014 03:40:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/11 v2] xfs: check xfs_buf_read_uncached returns
	correctly
Message-ID: <20140929104006.GB13582@infradead.org>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-11-git-send-email-david@fromorbit.com>
	<20140926102148.GF22194@infradead.org>
	<20140926232012.GQ4945@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926232012.GQ4945@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> Updated patch below.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
