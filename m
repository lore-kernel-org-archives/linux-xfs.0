Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 91E667CA2
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 22:50:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12FEEAC002
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 20:50:09 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id r26cyGxMuNXFtd4O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 20:50:06 -0700 (PDT)
Date: Tue, 19 Jul 2016 05:50:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: iomap infrastructure and multipage writes V5
Message-ID: <20160719035004.GA16780@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<20160628002649.GI12670@dastard> <20160630172239.GA23082@lst.de>
	<20160718111400.GC16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160718111400.GC16044@dastard>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jul 18, 2016 at 09:14:00PM +1000, Dave Chinner wrote:
> Any progress here, Christoph?

Nothing after the last posting yet.  Shortly after that I left to Japan
for about two weeks of hiking and a conference, which doesn't help my
ability to spend some quiet hours with the code.   It's on top of
my priority list for non-trivial things and I should be able to get
back it tomorrow after finishing the next conference today..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
