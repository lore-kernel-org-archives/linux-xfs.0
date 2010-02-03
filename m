Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13KU1D6243100 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:30:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 199451C9E986
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 12:31:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 824A2RNaoDysYjru for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:31:10 -0800 (PST)
Date: Wed, 3 Feb 2010 15:31:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] increase readdir buffer size
Message-ID: <20100203203110.GA24818@infradead.org>
References: <4B69B755.2030008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B69B755.2030008@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Feb 03, 2010 at 11:50:13AM -0600, Eric Sandeen wrote:
> so the default buffer is 4 * 8192 = 32768
> (except in the unlikely case of blocks > 32k....)
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
