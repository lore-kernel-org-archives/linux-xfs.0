Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27KIG4s176699 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 14:18:16 -0600
Subject: Re: [PATCH 3/3] xfs_io: add fpunch command for hole punching via
	fallocate
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110305002453.815562682@bombadil.infradead.org>
References: <20110305002222.395571492@bombadil.infradead.org>
	<20110305002453.815562682@bombadil.infradead.org>
Date: Mon, 07 Mar 2011 14:19:48 -0600
Message-ID: <1299529188.2578.848.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: josef@redhat.com, xfs@oss.sgi.com

On Fri, 2011-03-04 at 19:22 -0500, Christoph Hellwig wrote:
> plain text document attachment (add-fpunch-command)
> Add a fpunch command which simply uses fallocate to punch a hole for the
> given offset and length.
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good too.  I haven't tested these yet but
they look fine to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
