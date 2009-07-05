Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n65JcFvs045012 for <xfs@oss.sgi.com>; Sun, 5 Jul 2009 14:38:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BE29342DDF
	for <xfs@oss.sgi.com>; Sun,  5 Jul 2009 12:38:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NwSl991HZV5W3ySu for
	<xfs@oss.sgi.com>; Sun, 05 Jul 2009 12:38:48 -0700 (PDT)
Date: Sun, 5 Jul 2009 15:38:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH (trivial)] remove XFS_INO64_OFFSET
Message-ID: <20090705193848.GA1330@infradead.org>
References: <4A50E197.3070209@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A50E197.3070209@sandeen.net>
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

On Sun, Jul 05, 2009 at 12:23:35PM -0500, Eric Sandeen wrote:
> Commit a19d9f887d81106d52cacbc9930207b487e07e0e removed the
> ino64 option but left the XFS_INO64_OFFSET define it used
> in place - just remove it.

Looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
