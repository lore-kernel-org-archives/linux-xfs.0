Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RANAE0187716 for <xfs@oss.sgi.com>; Wed, 27 May 2009 05:23:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47DB710178DE
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 03:29:17 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KyJ9pRZtvrUaMthE for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 03:29:17 -0700 (PDT)
Date: Wed, 27 May 2009 06:23:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add more statics & drop some unused functions
Message-ID: <20090527102319.GA28274@infradead.org>
References: <4A1C3D65.4020306@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A1C3D65.4020306@sandeen.net>
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

On Tue, May 26, 2009 at 02:05:09PM -0500, Eric Sandeen wrote:
> A lot more functions could be made static, but they need
> forward declarations; this does some easy ones, and also 
> found a few unused functions in the process.

Looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
