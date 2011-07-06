Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p668BeRZ091603 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:11:41 -0500
Date: Wed, 6 Jul 2011 04:11:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/27] xfs: split xfs_itruncate_finish
Message-ID: <20110706081138.GA5361@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094603.580931463@bombadil.infradead.org>
	<1309926958.3381.61.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309926958.3381.61.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 11:35:58PM -0500, Alex Elder wrote:
> The above comment (if true--I haven't really checked) seems
> like something significant to preserve.

The comment at the goto label already catches the important bits of it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
