Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BA2D7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:58:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A24CDAC007
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 10:58:02 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id dfB7Eof9CGZl8sel (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 10:58:00 -0700 (PDT)
Date: Thu, 5 May 2016 13:57:57 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1098550743.2009870.1462471077229.JavaMail.zimbra@redhat.com>
In-Reply-To: <1462310947-16132-7-git-send-email-hch@lst.de>
References: <1462310947-16132-1-git-send-email-hch@lst.de>
	<1462310947-16132-7-git-send-email-hch@lst.de>
Subject: Re: [PATCH 06/14] xfs: remove buffered write support from
	__xfs_get_blocks
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

----- Original Message -----
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 77
>  +++++++++++++++----------------------------------------
>  1 file changed, 21 insertions(+), 56 deletions(-)
> 

Reviewed-by: Bob Peterson <rpeterso@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
