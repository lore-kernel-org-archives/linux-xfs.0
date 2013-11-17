Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 821887F4E
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 04:06:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F2DA8F8054
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 02:06:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id qw4OxVXCTnKOVczQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 02:06:46 -0800 (PST)
Date: Sun, 17 Nov 2013 02:06:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs_fsr: extra debugging info
Message-ID: <20131117100645.GA31408@infradead.org>
References: <5261B11F.1040000@redhat.com>
 <5261B183.7040309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5261B183.7040309@redhat.com>
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

On Fri, Oct 18, 2013 at 05:09:07PM -0500, Eric Sandeen wrote:
> Provide 2 new pieces of information when -d is specified to
> xfs_fsr:
> 
> * If we needed to grow the forkoffset and couldn't
> * If we were unable to match the fork offset
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
