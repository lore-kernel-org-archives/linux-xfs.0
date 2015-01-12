Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD0DD7F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 06:43:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB699304039
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 04:43:05 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id c8RFlVAWKn6a0QPY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 04:43:04 -0800 (PST)
Date: Mon, 12 Jan 2015 13:43:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150112124302.GA29681@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
	<20150112045606.GA107426@slacker.internal.excfb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150112045606.GA107426@slacker.internal.excfb.com>
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
To: Tom Haynes <thomas.haynes@primarydata.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sun, Jan 11, 2015 at 11:56:06PM -0500, Tom Haynes wrote:
> Could you follow the client code convention by putting
> each layout type in a directory?

I have to say I hate that convention on the client side, so I'd
be happier to keep it as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
