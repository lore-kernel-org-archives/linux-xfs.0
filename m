Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BCk85Y000683 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 07:46:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78BAB1F1458E
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 05:46:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GjXMwBCx50NpbXmC for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 05:46:06 -0700 (PDT)
Date: Tue, 11 Oct 2011 08:46:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfstests: allow 091 for non-xfs filesystems
Message-ID: <20111011124603.GB2070@infradead.org>
References: <20111010182156.GA1323@infradead.org>
	<20111010182216.GA1335@infradead.org>
	<20111010182233.GB1335@infradead.org>
	<20111011021132.GA3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111011021132.GA3159@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> Given that the test is not run on irix, I'd change the _supported_os
> line to just Linux as well, and kill the separate check for Irix
> while you are there.

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
