Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86FJZY4087603 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 10:19:35 -0500
Subject: Re: [PATCH 06/25] xfs: remove xfs_bmapi_single()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060641.541211477@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060641.541211477@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:23:18 -0500
Message-ID: <1315002198.2069.86.camel@doink>
MIME-Version: 1.0
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> Now we have xfs_bmapi_read, there is no need for xfs_bmapi_single().
> Change the remaining caller over and kill the function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Nice.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
