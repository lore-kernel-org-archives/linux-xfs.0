Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 400837FCD
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 08:56:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE60DAC002
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 06:56:23 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id yvtGnOE1kTaPuwkT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 06:56:22 -0800 (PST)
Date: Mon, 2 Feb 2015 15:56:19 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/20] nfsd: implement pNFS operations
Message-ID: <20150202145619.GA18387@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-11-git-send-email-hch@lst.de>
	<20150129203346.GA11064@fieldses.org>
	<20150202124349.GA15598@lst.de>
	<20150202142832.GC22301@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202142832.GC22301@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 09:28:32AM -0500, J. Bruce Fields wrote:
> I didn't notice anything that looked like a big problem to me, so absent
> any objections I'll commit the revised versions for 3.20 once we figure
> out how to handle the xfs stuff.

Do you want the resend to be on top of Jeffs locks tree, or do you
want me to be based just on the nfsd changes, which would require
a fairly trivial merge once both of the trees hit mainline?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
