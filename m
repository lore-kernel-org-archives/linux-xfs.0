Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14F8A7CB8
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:24:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ABEFAC001
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:23:59 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CIAPzCdJpGLBjxid (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:23:57 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:23:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 1/2] Remove workaround for getsubopt() on
	<glibc-2.2
Message-ID: <20160801062355.GA596@infradead.org>
References: <20160730133725.GA5895@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160730133725.GA5895@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Jul 30, 2016 at 03:37:25PM +0200, Felix Janda wrote:
> The workaround addressed only a const-correctness warning.
> It was wrongly applied also to alternative c libraries on linux.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Didn't I ACK this before?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
