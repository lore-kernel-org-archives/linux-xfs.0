Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83E047CBB
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 09:33:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 549E38F8054
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:33:05 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GAE8kzYozsXn9IGY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 07:33:03 -0700 (PDT)
Date: Thu, 21 Jul 2016 07:33:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to dc4113d2
Message-ID: <20160721143302.GB27521@infradead.org>
References: <20160720051017.GJ16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160720051017.GJ16044@dastard>
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

On Wed, Jul 20, 2016 at 03:10:17PM +1000, Dave Chinner wrote:
> has just been updated. Christoph, I pulled all of your DAX vs DIO
> patchset except for the last patch that changed the locking. I'm
> still undecided on that and my focus is on other things (like rmap)
> right now, so I've left it out for the moment.

Sure, let's postponed it for now, given that experimental status
of DAX it's probably not too urgent.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
