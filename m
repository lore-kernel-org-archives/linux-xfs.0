Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATItHmO090256 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 12:55:17 -0600
Date: Tue, 29 Nov 2011 13:55:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] [PATCH] xfs: fix attr2 vs large data fork assert
Message-ID: <20111129185512.GA16435@infradead.org>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.498870090@bombadil.infradead.org>
	<20111116231517.GA7046@dastard>
	<20111117073004.GB3733@infradead.org>
	<20111129184816.GV29840@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111129184816.GV29840@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 29, 2011 at 12:48:16PM -0600, Ben Myers wrote:
> FYI, Test 117 also hit it for me after I backed off 'freeze fsstress
> options'.  Are you still planning on adding a copy of the test with the
> seeds in question?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
