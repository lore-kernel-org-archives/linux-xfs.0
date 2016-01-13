Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC30C7F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:55:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA888304059
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id UiZcfu0k2vjiZBqd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:25 -0800 (PST)
Date: Tue, 12 Jan 2016 23:55:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] fsr/xfs_fsr.c: Include <paths.h> for _PATH_MOUNTED
Message-ID: <20160113075525.GD21939@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195953.GD568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112195953.GD568@nyan>
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

On Tue, Jan 12, 2016 at 08:59:53PM +0100, Felix Janda wrote:
> Fixes a compilation failure with musl libc
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
