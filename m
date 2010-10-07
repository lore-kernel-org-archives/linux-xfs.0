Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o97KNeNB221720 for <xfs@oss.sgi.com>; Thu, 7 Oct 2010 15:23:40 -0500
Subject: Re: [PATCH 5/7] xfs: remove xfs_globals.h
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101006184126.419695420@localhost.localdomain>
References: <20101006184111.634126439@localhost.localdomain>
	<20101006184126.419695420@localhost.localdomain>
Date: Thu, 07 Oct 2010 15:24:45 -0500
Message-ID: <1286483085.2670.371.camel@doink>
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
Cc: xfs@oss.sgi.com

On Wed, 2010-10-06 at 14:41 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-kill-globals.h)
> This header only provides one extern that isn't actually declared anywhere,
> and shadowed by a macro.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
