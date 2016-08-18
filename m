Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 541657CA1
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:42:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0A56AC001
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:42:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DbQoPyw2HLSCR717 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:42:21 -0700 (PDT)
Date: Thu, 18 Aug 2016 10:42:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 09/14] fadvise.c: replace posix_fadvise64 by
	equivalent posix_fadvise
Message-ID: <20160818174219.GI27799@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<94800ca4e791ebca9ad6503afba31ebdfad672f7.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <94800ca4e791ebca9ad6503afba31ebdfad672f7.1471107858.git.felix.janda@posteo.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 13, 2016 at 06:03:16PM +0200, Felix Janda wrote:
> also fixes a compile failure on FreeBSD
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
