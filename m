Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6D777CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:33:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 597558F8040
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 05:33:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OS0cqhubKAIJY1FC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:33:13 -0700 (PDT)
Date: Wed, 1 Jun 2016 05:33:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs: for-next branch update to 26f1fe8
Message-ID: <20160601123313.GA32705@infradead.org>
References: <20160601083455.GK12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160601083455.GK12670@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Jun 01, 2016 at 06:34:55PM +1000, Dave Chinner wrote:
>       [a3916e5] xfs: fix broken multi-fsb buffer logging

Isn't this something we should try to get into 4.7?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
