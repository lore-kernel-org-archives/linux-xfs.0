Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78C3A7F37
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 18:20:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52AB78F804B
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 16:20:38 -0800 (PST)
Date: Thu, 20 Feb 2014 16:20:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: add support for O_TMPFILE opens
Message-ID: <20140221002036.GA18972@infradead.org>
References: <20140220220000.GA17541@infradead.org>
	<8D3FA7645C1CFC4E9E783D22B4C708644B2AF1@P-EXMB2-DC21.corp.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8D3FA7645C1CFC4E9E783D22B4C708644B2AF1@P-EXMB2-DC21.corp.sgi.com>
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
To: Shaun Gosse <sgosse@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Feb 21, 2014 at 12:16:58AM +0000, Shaun Gosse wrote:
> Very minor point, but you've got a typo in the documentation portion of your patch.
> 
> +create a temporary file not linked into the filesystem namepspace 
> 
> Should be "namespace" of course.

Thanks Shaun, I'll fix it for the next version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
