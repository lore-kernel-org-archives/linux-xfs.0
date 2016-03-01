Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77EFE7CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 12:22:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E210BAC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 10:22:35 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 08xFzfVuLzN0ABu5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 10:22:33 -0800 (PST)
Date: Tue, 1 Mar 2016 10:22:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove impossible condition
Message-ID: <20160301182227.GA21238@infradead.org>
References: <1456404237-18169-1-git-send-email-luisbg@osg.samsung.com>
	<20160301120814.GA5217@infradead.org>
	<56D597D5.3040002@osg.samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56D597D5.3040002@osg.samsung.com>
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
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: cmaiolino@redhat.com, darrick.wong@oracle.com, namjae.jeon@samsung.com, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, billodo@redhat.com

On Tue, Mar 01, 2016 at 01:23:33PM +0000, Luis de Bethencourt wrote:
> If you have some specific things in mind that I could fix in the code around
> this, I am happy to add it to my ToDo list. Or I can continue reading it and
> let you know of anything I see, so you can confirm before I try to fix it.

I don't think this mess is something I want to let newbies loose on :)

Thanks a lot for the patch again!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
