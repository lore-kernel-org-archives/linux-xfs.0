Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A2E27F52
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 05:32:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07DAB30405F
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 03:32:44 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id XHzfppW7vbz6RzCU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 03:32:42 -0800 (PST)
Date: Wed, 11 Nov 2015 03:32:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20151111113241.GA7083@infradead.org>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20150831180221.GA16371@bfoster.bfoster>
	<20150831185612.GB349@infradead.org>
	<20150831221743.GI26895@dastard>
	<20150901074103.GA27231@infradead.org>
	<20151110232543.GH14311@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151110232543.GH14311@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Nov 11, 2015 at 10:25:43AM +1100, Dave Chinner wrote:
> Did the work for arbitrarily sized bios ever get merged? I can't
> find any evidence that it did....

Yes, it landed in 4.3.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
