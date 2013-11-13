Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E6497F51
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 01:55:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04FBC304066
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 23:55:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id taHBvHkTBWbgMuck (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 23:55:23 -0800 (PST)
Date: Tue, 12 Nov 2013 23:55:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 36/37] repair: Increase default repair parallelism on
	large filesystems
Message-ID: <20131113075522.GA7018@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-37-git-send-email-david@fromorbit.com>
	<20131106104111.GB21067@infradead.org>
	<20131106191345.GD6188@dastard> <20131112233807.GD6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131112233807.GD6188@dastard>
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

On Wed, Nov 13, 2013 at 10:38:07AM +1100, Dave Chinner wrote:
> I'll do that in a separate patch series, as it's not directly
> related to this initial introduction of the feature to repair.

Ok, fine with me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
