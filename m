Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41E3C7F3F
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 01:10:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19ADC304066
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 23:10:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hXE7QKtwgNUeK5H8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 23:10:26 -0800 (PST)
Date: Fri, 7 Feb 2014 23:10:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove XFS_TRANS_DEBUG dead code
Message-ID: <20140208071026.GB25719@infradead.org>
References: <52F1065F.8040904@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F1065F.8040904@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Feb 04, 2014 at 11:25:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Remove the leftover XFS_TRANS_DEBUG dead code following the previous
> cleaning up of it in commits ec47eb6b0b450.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
