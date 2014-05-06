Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94EB67FC9
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:05:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67EC98F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:05:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id DcouWFC5TSQrBHjA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:05:05 -0700 (PDT)
Date: Tue, 6 May 2014 01:05:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix directory readahead offset off-by-one
Message-ID: <20140506080504.GA24143@infradead.org>
References: <1399347728-19752-1-git-send-email-david@fromorbit.com>
	<20140506075637.GA13191@infradead.org>
	<20140506080236.GD5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506080236.GD5421@dastard>
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

On Tue, May 06, 2014 at 06:02:36PM +1000, Dave Chinner wrote:
> yeah, I can do that.


Reviewed-by: Christoph Hellwig <hch@lst.de>

with that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
