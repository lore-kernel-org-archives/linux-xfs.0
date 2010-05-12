Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4CFlWq7171109 for <xfs@oss.sgi.com>; Wed, 12 May 2010 10:47:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B5E115651C1
	for <xfs@oss.sgi.com>; Wed, 12 May 2010 08:50:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xwQonnJJbwDaFk4d for
	<xfs@oss.sgi.com>; Wed, 12 May 2010 08:50:16 -0700 (PDT)
Date: Wed, 12 May 2010 11:49:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdocs: fix image scaling for pdf
Message-ID: <20100512154945.GA1573@infradead.org>
References: <4BEACCA0.3070300@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BEACCA0.3070300@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, May 12, 2010 at 10:43:28AM -0500, Eric Sandeen wrote:
> Apparently having: format="PNG" width="100%" scalefit="0"
> in the image attributes is messing up scaling on the pdf
> such that the images extend beyond the page.  (I inherited
> all that from work our techpubs guy did).  On the advice
> of another techpubs / publican expert, remove it - this 
> seems to fix up the sizing on the pdf build.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
