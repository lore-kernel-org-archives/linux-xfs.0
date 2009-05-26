Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QK2nNC158373 for <xfs@oss.sgi.com>; Tue, 26 May 2009 15:02:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3F992AE714
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 13:03:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id qXJFozFbn431iKrQ for
	<xfs@oss.sgi.com>; Tue, 26 May 2009 13:03:03 -0700 (PDT)
Date: Tue, 26 May 2009 16:03:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] drop xfs_version.h
Message-ID: <20090526200303.GA18261@infradead.org>
References: <4A1C449E.7070004@sandeen.net>
	<20090526195140.GA4368@infradead.org>
	<4A1C4A44.1030309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1C4A44.1030309@sandeen.net>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, May 26, 2009 at 03:00:04PM -0500, Eric Sandeen wrote:
> xfs_version.h is about 30 lines for the benefit of 
> one single define, which seems a bit silly.
> 
> Just drop the file and hardcode "SGI XFS" the 2 
> places it's used.
> 
> v2: merge together 2 now-shorter lines.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
