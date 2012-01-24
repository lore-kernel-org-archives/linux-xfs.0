Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OFZdTg034884 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 09:35:39 -0600
Message-ID: <4F1ECFCB.9000503@sgi.com>
Date: Tue, 24 Jan 2012 09:35:39 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 06/12] xfs: add the xlog_grant_head structure
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.475114637@bombadil.infradead.org>
In-Reply-To: <20111212141434.475114637@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Add a new data structure to allow sharing code between the log grant and
> regrant code.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>


looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
