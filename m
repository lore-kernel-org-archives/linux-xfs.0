Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 035B07F54
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:17:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E98BC8F8068
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:17:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id uAKtHPH0j7GDiVTk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:17:03 -0800 (PST)
Date: Fri, 13 Dec 2013 03:17:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: set umask to avoid spurious generic/314 test
	failures
Message-ID: <20131213111702.GE23546@infradead.org>
References: <20130921211735.GC7855@wallace>
 <52AA87B6.6010607@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AA87B6.6010607@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good to me too,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
