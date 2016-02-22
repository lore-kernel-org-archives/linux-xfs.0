Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A2387F47
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 03:20:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF907304090
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 01:19:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id N2dDUNdbDipK9Hi4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 01:03:01 -0800 (PST)
Date: Mon, 22 Feb 2016 01:03:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_db: Fix dquot command docs
Message-ID: <20160222090301.GA14345@infradead.org>
References: <56C77A29.7070806@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C77A29.7070806@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 19, 2016 at 02:25:13PM -0600, Eric Sandeen wrote:
> The dquot command in xfs_db takes quota type as well as an ID.
> Fix the usage & man page to reflect this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
