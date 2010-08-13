Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DCU3X0056869 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 07:30:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63B51701FF1
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:30:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TDEpyYmVJZaxdx55 for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:30:29 -0700 (PDT)
Date: Fri, 13 Aug 2010 08:30:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 228: suppress core dump message
Message-ID: <20100813123026.GB14650@infradead.org>
References: <4C0FB207.20706@sandeen.net>
 <4C644269.20109@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C644269.20109@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Ugly stuff, but hey the workaround looks correct,


Reviewed-by: Christoph Hellwig <hch@lst.de>

I wish RH wouldn't play such stupid games with core dumps.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
