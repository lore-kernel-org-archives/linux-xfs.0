Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACFZNbG233180 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 09:35:23 -0600
Message-ID: <50A117B2.4080501@sgi.com>
Date: Mon, 12 Nov 2012 09:37:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/32] xfs: add CRC infrastructure
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-32-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/12/12 05:54, Dave Chinner wrote:
> From: Christoph Hellwig<hch@lst.de>
>
>   - add a mount feature bit for CRC enabled filesystems
>   - add some helpers for generating and verifying the CRCs
>   - add a copy_uuid helper
>
> The checksumming helpers are losely based on similar ones in sctp,
> all other bits come from Dave Chinner.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
