Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9GnE8081350 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:17:09 -0500
Date: Mon, 16 Mar 2009 05:16:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Pagecache usage optimization on XFS
Message-ID: <20090316091606.GA1720@infradead.org>
References: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
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
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

This looks like it should work.  did you run XFSQA on a small blocksize
filesystem with this applied?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
