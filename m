Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E71D17F55
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 04:16:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9924B8F8065
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:16:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id FQ3vGXfb0hrqMFkE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 02:16:22 -0700 (PDT)
Date: Tue, 22 Apr 2014 02:16:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfstests: add helper for zero range support check
Message-ID: <20140422091620.GA4980@infradead.org>
References: <20140421204023.GB960@wallace>
	<20140422062816.GB31337@infradead.org>
	<20140422091443.GG15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422091443.GG15995@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>

On Tue, Apr 22, 2014 at 07:14:43PM +1000, Dave Chinner wrote:
> I don't really care either way, as long as all the checks are done
> consistently. Send a patch to change them all... :)

My flink test already avoids the wrapper :)

So how about we stop adding them for now at least.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
