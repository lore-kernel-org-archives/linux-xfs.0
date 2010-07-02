Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6276mY1231847 for <xfs@oss.sgi.com>; Fri, 2 Jul 2010 02:06:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75DF71E1D267
	for <xfs@oss.sgi.com>; Fri,  2 Jul 2010 00:09:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZutovSqVqdfP86ha for
	<xfs@oss.sgi.com>; Fri, 02 Jul 2010 00:09:36 -0700 (PDT)
Date: Fri, 2 Jul 2010 03:09:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfstests] filter 237 setfacl output
Message-ID: <20100702070935.GA30776@infradead.org>
References: <4C2CF2CB.9030706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2CF2CB.9030706@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 01, 2010 at 02:55:55PM -0500, Eric Sandeen wrote:
> Older setfacl error output seems to include the full path to
> the file; filter it out.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
