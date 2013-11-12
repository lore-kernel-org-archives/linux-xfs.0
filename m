Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05B037F90
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:38:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D44A28F8049
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:38:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id ETNiwm2PCLHU6Yd3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 09:38:30 -0800 (PST)
Date: Tue, 12 Nov 2013 09:38:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: remove xfs_check references from fsck.xfs
	script & manpage
Message-ID: <20131112173830.GF19554@infradead.org>
References: <528257D0.7050404@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528257D0.7050404@redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 12, 2013 at 10:31:12AM -0600, Eric Sandeen wrote:
> xfs_check is deprecated & slated for removal in June 2014.
> 
> We can stop referring to it now, though - pointing fsck.xfs
> users to it doesn't make sense at this point.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
