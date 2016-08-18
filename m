Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BA1D7CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 16:56:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D3FA68F8035
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 14:56:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Exjo0MSH3v8TZpYs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 14:56:42 -0700 (PDT)
Date: Thu, 18 Aug 2016 14:56:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: dropping IRIX support in xfsprogs
Message-ID: <20160818215642.GA17607@infradead.org>
References: <20160818174742.GA14464@infradead.org>
	<20160818205914.GI19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160818205914.GI19025@dastard>
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

On Fri, Aug 19, 2016 at 06:59:14AM +1000, Dave Chinner wrote:
> We dropped support for older irix only filesystems some time ago,
> so this seems like a natural progression from that. I have no
> objections to removing it...

Ok, I'll start sending patches once you're ok (or not ok)
with the patches from Felix to turn on LFS support to avoid
conflicting with those.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
