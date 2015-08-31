Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84E807F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:42:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59F248F8035
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:42:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bpi9hgrFYQ6XXvdx (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:41:59 -0700 (PDT)
Date: Mon, 31 Aug 2015 11:41:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: remove nonblocking mode from xfs_vm_writepage
Message-ID: <20150831184158.GA349@infradead.org>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440479153-1584-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
