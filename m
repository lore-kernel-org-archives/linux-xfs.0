Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3FGFs2d177311 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 11:15:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55E5A2C6312
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 09:17:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id p6QEyGVyrxAjVJ0W for
	<xfs@oss.sgi.com>; Thu, 15 Apr 2010 09:17:46 -0700 (PDT)
Date: Thu, 15 Apr 2010 12:17:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: make sure $seq.full files don't land in /
Message-ID: <20100415161745.GA21742@infradead.org>
References: <4BC5EDE6.7000001@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BC5EDE6.7000001@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 14, 2010 at 11:31:34AM -0500, Eric Sandeen wrote:
> 186 and 192, at least, were landing (part of) their $seq.full
> files in /
> 
> Fix this by using $here/$seq.full where needed.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
